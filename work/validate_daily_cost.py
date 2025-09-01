#!/usr/bin/env python3
"""
Daily Cost Validation Script for Coder Metadata Resources

This script scans Terraform files to ensure all coder_metadata resources
have the required daily_cost property with valid values.
"""

import os
import re
import sys
import json
from pathlib import Path
from typing import List, Dict, Any

class DailyCostValidator:
    def __init__(self):
        self.issues = []
        self.resources_checked = 0
        self.resources_with_issues = 0
        
    def scan_terraform_files(self, directory: str) -> List[str]:
        """Find all Terraform files in the given directory."""
        terraform_files = []
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith(('.tf', '.tfvars')):
                    terraform_files.append(os.path.join(root, file))
        return terraform_files
    
    def parse_coder_metadata_resources(self, file_path: str) -> List[Dict[str, Any]]:
        """Parse coder_metadata resources from a Terraform file."""
        resources = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Find all coder_metadata resource blocks
            pattern = r'resource\s+"coder_metadata"\s+"([^"]+)"\s*\{([^}]+)\}'
            matches = re.finditer(pattern, content, re.DOTALL)
            
            for match in matches:
                resource_name = match.group(1)
                resource_block = match.group(2)
                
                # Check for daily_cost property
                daily_cost_match = re.search(r'daily_cost\s*=\s*([^\s\n]+)', resource_block)
                
                resource_info = {
                    'file': file_path,
                    'resource_name': resource_name,
                    'resource_block': resource_block.strip(),
                    'has_daily_cost': daily_cost_match is not None,
                    'daily_cost_value': daily_cost_match.group(1) if daily_cost_match else None,
                    'line_number': self._get_line_number(content, match.start())
                }
                
                resources.append(resource_info)
                
        except Exception as e:
            self.issues.append({
                'type': 'parse_error',
                'file': file_path,
                'error': str(e)
            })
            
        return resources
    
    def _get_line_number(self, content: str, position: int) -> int:
        """Get the line number for a given position in content."""
        return content[:position].count('\n') + 1
    
    def validate_daily_cost_value(self, value: str) -> bool:
        """Validate that daily_cost is a positive number."""
        if not value:
            return False
            
        try:
            # Remove any quotes and convert to float
            clean_value = value.strip('"\'')
            num_value = float(clean_value)
            return num_value > 0
        except (ValueError, TypeError):
            return False
    
    def validate_resources(self, resources: List[Dict[str, Any]]) -> None:
        """Validate all coder_metadata resources."""
        for resource in resources:
            self.resources_checked += 1
            
            if not resource['has_daily_cost']:
                self.resources_with_issues += 1
                self.issues.append({
                    'type': 'missing_daily_cost',
                    'severity': 'error',
                    'file': resource['file'],
                    'resource_name': resource['resource_name'],
                    'line_number': resource['line_number'],
                    'message': f"Resource '{resource['resource_name']}' is missing required 'daily_cost' property"
                })
            else:
                # Validate the daily_cost value
                if not self.validate_daily_cost_value(resource['daily_cost_value']):
                    self.resources_with_issues += 1
                    self.issues.append({
                        'type': 'invalid_daily_cost',
                        'severity': 'error',
                        'file': resource['file'],
                        'resource_name': resource['resource_name'],
                        'line_number': resource['line_number'],
                        'daily_cost_value': resource['daily_cost_value'],
                        'message': f"Resource '{resource['resource_name']}' has invalid 'daily_cost' value: {resource['daily_cost_value']}"
                    })
    
    def generate_report(self) -> Dict[str, Any]:
        """Generate a comprehensive validation report."""
        report = {
            'summary': {
                'total_resources_checked': self.resources_checked,
                'resources_with_issues': self.resources_with_issues,
                'compliance_rate': f"{((self.resources_checked - self.resources_with_issues) / self.resources_checked * 100):.1f}%" if self.resources_checked > 0 else "0%"
            },
            'issues': self.issues,
            'status': 'PASS' if self.resources_with_issues == 0 else 'FAIL'
        }
        return report
    
    def print_report(self, report: Dict[str, Any]) -> None:
        """Print a formatted validation report."""
        print("=" * 80)
        print("DAILY COST VALIDATION REPORT")
        print("=" * 80)
        print(f"Status: {report['status']}")
        print(f"Resources Checked: {report['summary']['total_resources_checked']}")
        print(f"Resources with Issues: {report['summary']['resources_with_issues']}")
        print(f"Compliance Rate: {report['summary']['compliance_rate']}")
        print()
        
        if report['issues']:
            print("ISSUES FOUND:")
            print("-" * 40)
            for issue in report['issues']:
                print(f"Type: {issue['type']}")
                print(f"File: {issue['file']}")
                if 'resource_name' in issue:
                    print(f"Resource: {issue['resource_name']}")
                if 'line_number' in issue:
                    print(f"Line: {issue['line_number']}")
                if 'daily_cost_value' in issue:
                    print(f"Value: {issue['daily_cost_value']}")
                print(f"Message: {issue['message']}")
                print()
        else:
            print("✅ All coder_metadata resources are compliant!")
            print()
        
        print("=" * 80)
    
    def run_validation(self, directory: str) -> int:
        """Run the complete validation process."""
        print(f"Scanning directory: {directory}")
        
        # Find Terraform files
        terraform_files = self.scan_terraform_files(directory)
        print(f"Found {len(terraform_files)} Terraform files")
        
        # Parse and validate resources
        all_resources = []
        for file_path in terraform_files:
            resources = self.parse_coder_metadata_resources(file_path)
            all_resources.extend(resources)
        
        print(f"Found {len(all_resources)} coder_metadata resources")
        
        # Validate resources
        self.validate_resources(all_resources)
        
        # Generate and print report
        report = self.generate_report()
        self.print_report(report)
        
        # Return exit code (0 for success, 1 for failure)
        return 0 if report['status'] == 'PASS' else 1

def main():
    """Main entry point."""
    if len(sys.argv) != 2:
        print("Usage: python3 validate_daily_cost.py <directory>")
        print("Example: python3 validate_daily_cost.py .")
        sys.exit(1)
    
    directory = sys.argv[1]
    
    if not os.path.exists(directory):
        print(f"Error: Directory '{directory}' does not exist")
        sys.exit(1)
    
    validator = DailyCostValidator()
    exit_code = validator.run_validation(directory)
    
    sys.exit(exit_code)

if __name__ == "__main__":
    main()
