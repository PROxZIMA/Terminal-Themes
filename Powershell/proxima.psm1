#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # Starting 3 symbols
    $prompt += Write-Prompt -Object ([char]::ConvertFromUtf32(0x276F)) -ForegroundColor  $sl.Colors.GitNoLocalChangesAndAheadColor
    $prompt += Write-Prompt -Object ([char]::ConvertFromUtf32(0x276F)) -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.TildeSymbol) " -ForegroundColor $sl.Colors.PromptHighlightColor


    # Writes the drive portion
    $prompt += Write-Prompt -Object "$(Get-ShortPath -dir $pwd) " -ForegroundColor $sl.Colors.DriveForegroundColor

    # Write VirtualEnv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
    }

    # Write Git
    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object "on $($sl.PromptSymbols.SegmentBackwardSymbol) " -ForegroundColor $sl.Colors.BracketSymbolColor
        $prompt += Write-Prompt -Object $themeInfo.VcInfo -ForegroundColor $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.BracketSymbolColor
    }

    $prompt += Set-Newline

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.FailedCommandSymbol -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor
    }Else{
        $prompt += Write-Prompt -Object $sl.PromptSymbols.FailedCommandSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
    }

    $prompt += Write-Prompt -Object " $($sl.PromptSymbols.PromptIndicator) " -ForegroundColor $sl.Colors.WithForegroundColor
    $prompt
}


$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x279C)
$sl.PromptSymbols.TildeSymbol = '~'
$sl.PromptSymbols.SegmentForwardSymbol = ']'
$sl.PromptSymbols.SegmentBackwardSymbol = '['
$sl.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0x25B6)
$sl.Colors.BracketSymbolColor = [ConsoleColor]::DarkRed
$sl.Colors.CommandFailedIconForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.GitNoLocalChangesAndAheadColor = [ConsoleColor]::DarkMagenta
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Green
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Blue
$sl.Colors.DriveForegroundColor = [ConsoleColor]::Cyan
$sl.Colors.WithBackgroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithForegroundColor = [ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::Magenta