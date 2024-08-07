chart () {
    pushd . > /dev/null
    cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"
    tools/chart.sh $@
    popd > /dev/null    
}