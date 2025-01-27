# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

using module ../Classes/ValeApplicationInfo.psm1

function Get-Vale {
  [CmdletBinding()]
  [OutputType([ValeApplicationInfo])]
  param()

  process {
    $ValeCommand = Get-Command -Name vale -ErrorAction Ignore

    if ($null -eq $ValeCommand) {
      $ValeCommand = Get-Command "$(Get-Location)/.vale/vale" -ErrorAction Ignore
    }

    if ($null -eq $ValeCommand) {
      $Message = @(
        "Can't find vale installed in path or workspace."
        'You can use the Install-WorkspaceVale command or use your package manager to install it.'
      ) -join ' '
      throw  $Message
    }

    return [ValeApplicationInfo]::new($ValeCommand)
  }
}
