
function yolo () {
    function elapsed_time($duration) {
        $output = "{0:hh} hours {0:mm} minutes {0:ss} seconds" -f $duration
        return $output
    }
    
    #Variables
    $start = (Get-Date)
    $use_start = (Get-Date)
    $use_duration = New-TimeSpan
    $pause_duration = New-TimeSpan
    $previous_minutes = $use_duration.TotalMinutes
    $pause = $false
    $paused = $false
    $end = $false

    Write-Host ("YOLO Activated at " + ($start -f "MM/dd/yyyy HH:mm"))
    Write-Host ("Press F6 to Pause or F8 to stop")

    while ($end -eq $false) {
        if ([System.Console]::KeyAvailable) {
            $press = [System.Console]::Readkey()
            switch ($press.key) {
                F5 { Write-Host("Actively used so far: " + (elapsed_time($use_duration)))}
                F6 { $pause = $true }
                F8 { $end = $true }
            }
        }
        if ($pause -eq $true) {
            $pause_start = (Get-Date)
            Write-Host ("Press F6 to resume or F8 to stop");
            Write-Host ("Actively used so far: " + (elapsed_time($use_duration)))
            do {
                $press = [System.Console]::ReadKey()
                switch ($press.key) {
                    F6 {
                        $pause = $false;
                        $paused = $true;
                        $pause_duration += (Get-Date) - $pause_start;
                        Write-Host ("Resuming...");
                    }
                    F8 {
                        $pause_duration += (Get-Date) - $pause_start
                        $end = $true
                    }
                }
            }
            while ($press.key -notmatch 'F6|F8')
        }
        if ($end -eq $true) {
            $total_duration = (Get-Date) - $start
            Write-Host ("Stopping Script...");
            Write-Host ("Started at: " + ($start -f "MM/dd/yyyy HH:mm"));
            Write-Host ("Total Duration: " + (elapsed_time($total_duration)))
            Write-Host ("Actively Used: " + (elapsed_time($use_duration)));
            exit
        }
        else {
            if ($paused -eq $true) {
                $paused = $false
            }
            else {
                $use_duration = $use_duration.add((Get-Date) - $use_start)
            }
            $use_start = (Get-Date)
            if ($use_duration.TotalMinutes -gt $previous_minutes) {
                $wsh = New-Object -ComObject Wscript.Shell
                $wsh.SendKeys('{CAPSLOCK}')
                $wsh.SendKeys('{CAPSLOCK}')
                Remove-Variable wsh
                $previous_minutes = $use_duration.TotalMinutes + 1
                Start-Sleep -Seconds 1
                Write-Host "Booya!"
            }
            else {
                Start-Sleep -Seconds 1
            }
            
        }
    }
}

Yolo

