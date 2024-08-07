show_help (){
    cat <<EOF 
Usage: $(basename $0) [command] [chart]
    Commands:
        build   -   Create the README File for the [chart]
        create  -   Create a new chart with the name of [chart]
        lint    -   Lint [chart] with chart-testing
        update  -   Update the dependencies on [chart]
        addcore -   Add the local version of FunkyCore to [chart]
        addpkg  -   Adds the 3rd parameter to [chart]
        prepush -   Updates readme, updates dependencies and lints chart (The pre-push package!)

    Dependencies:
        https://github.com/helm/chart-testing

        $ gofish install helm
        $ pip install yamale yamllint ruamel.yaml pystache

EOF
}

cmd_build(){
    python tools/mkreadme.py tools/README.MD.TEMPLATE $CHART/README.MD $CHART/Chart.yaml $CHART/values.yaml
}

cmd_create(){
    cp -rf tools/helm-boilerplate/ $CHART/
    find $CHART -type f -exec sed -i "s/<CHARTNAME>/$CHARTNAME/g" {} \;
}

cmd_lint(){
    ct lint --charts $CHART --config .ci/ct-config.yaml
}

cmd_update(){
    helm dep update $CHART
}

cmd_addpkg(){
    helm package charts/$1
    mv $1*.tgz $CHART/charts 
}

cmd_install(){
    helm install $1 charts/$1/ -n staging -f testvals/$1.yaml
}

pushd . > /dev/null
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/../"

CHARTNAME=$2
CHART=charts/$CHARTNAME


case "$1" in 
    "build")
        cmd_build
        ;;

    "create")
        cmd_create $2
        ;;

    "lint")
        cmd_lint
        ;;

    "update")
        cmd_update
        ;;
    "addcore")
        cmd_addpkg funkycore
        ;;
    "addpkg")
        cmd_addpkg $3
        ;;
    "prepush")
        cmd_build
        cmd_update
        cmd_lint
        ;;
    "install")
        cmd_install $2
        ;;
    *)
        show_help
esac

popd > /dev/null