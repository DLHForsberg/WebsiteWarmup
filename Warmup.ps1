[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$urls = @(
"https://example.com",
"https://example2.com",
"https://example3.com",
)

workflow Invoke-URLRequest
{
    param([parameter(Mandatory=$True)][String[]] $urls)

    $myoutput=@()
    
    ForEach -Parallel ($url in $urls)
    {
        $Result = Invoke-WebRequest -Method "GET" -Uri $url -TimeoutSec 600
        $Workflow:myoutput += $url + ":" + $Result.StatusCode
    }
    Return $myoutput
} 

try {
        $WakeUp = Invoke-URLRequest -urls $urls -ErrorAction SilentlyContinue
        $FinalResults = Invoke-URLRequest -urls $urls -ErrorAction SilentlyContinue
    }
catch {}

$Failed=@()
ForEach ($url in $urls){
    if ($FinalResults -notcontains $url + ":200")
    {
        $Failed += $url
    }
}

$OutputResults = $null
if (!$Failed) {$OutputResults = "None failed"} else {"Failed: " + $Failed}
$OutputResults
