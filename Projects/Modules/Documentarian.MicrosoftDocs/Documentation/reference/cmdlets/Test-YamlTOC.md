---
external help file: Documentarian.MicrosoftDocs-help.xml
Module Name: Documentarian.MicrosoftDocs
ms.date: 02/07/2023
schema: 2.0.0
title: Test-YamlTOC
---

# Test-YamlTOC

## SYNOPSIS
Validates that all entries in the TOC exist and that all files in the repository are in the TOC.

## SYNTAX

```
Test-YamlTOC [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

The cmdlet reads a `TOC.yml` file then verifies that every entry in the TOC exists in the
repository. After that, the cmdlet enumerates every `.md` and `.yml` file in the repository and
verifies that it exists in the TOC.

## EXAMPLES

### Example 1 - Verify a TOC file

In this example, the TOC contain site-relative URL links to docs in another repository. The first
two items can be ignored. The next two items were files that were deleted. The links still worked
because of redirection. However, it is best to remove or replace the entries with the proper path to
avoid redirection.

```powershell
Test-YamlTOC -Path .\docs-conceptual\toc.yml
```

```Output
File does not exist - /azure/automation/automation-dsc-getting-started
File does not exist - /azure/governance/policy/concepts/guest-configuration
File does not exist - dsc/tutorials/dscCiCd.md
File does not exist - samples/repeating-a-task-for-multiple-objects--foreach-object-.md
File not in TOC - developer/format/selectionsetname-element-for-entryselectedby-for-controls-for-configuration-format.md
File not in TOC - developer/help/writing-windows-powershell-help.md
File not in TOC - developer/scheduling-jobs-with-the-windows-powershell-api.md
```

The cmdlet also found three files that need to be added to the TOC.

## PARAMETERS

### -Path

The path to the TOC file.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose,
-WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
