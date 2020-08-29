#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $lastColor = $sl.Colors.StartBackgroundColor

    # Starting 3 symbols
    $prompt += Write-Prompt -Object "$([char]::ConvertFromUtf32(0x276F))$([char]::ConvertFromUtf32(0x276F))$($sl.PromptSymbols.TildeSymbol) " -ForegroundColor  $sl.Colors.SessionForegroundColorB -BackgroundColor $sl.Colors.StartBackgroundColor

    # Writes the drive portion
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $lastColor -BackgroundColor $sl.Colors.DriveBackgroundColor
    $prompt += Write-Prompt -Object "$(Get-ShortPath -dir $pwd) " -ForegroundColor  $sl.Colors.SessionForegroundColorB -BackgroundColor $sl.Colors.DriveBackgroundColor

    $lastColor = $sl.Colors.DriveBackgroundColor

    # Write VirtualEnv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $lastColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.SessionForegroundColorB -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $lastColor = $sl.Colors.VirtualEnvBackgroundColor
    }

    # Write Git
    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $lastColor -BackgroundColor $sl.Colors.GitBackgroundColor
        $prompt += Write-Prompt -Object "$($themeInfo.VcInfo) " -ForegroundColor $sl.Colors.SessionForegroundColorB -BackgroundColor $sl.Colors.GitBackgroundColor
        $lastColor = $sl.Colors.GitBackgroundColor
    }

    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $lastColor

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
$sl.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0x25B6)
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0B0)
$sl.Colors.CommandFailedIconForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.SessionForegroundColorB = [ConsoleColor]::Black
$sl.Colors.SessionForegroundColorW = [ConsoleColor]::White
$sl.Colors.StartBackgroundColor = [ConsoleColor]::DarkBlue
$sl.Colors.DriveBackgroundColor = [ConsoleColor]::DarkMagenta
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Blue
$sl.Colors.GitBackgroundColor = [ConsoleColor]::Cyan
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Green
$sl.Colors.WithForegroundColor = [ConsoleColor]::Red
