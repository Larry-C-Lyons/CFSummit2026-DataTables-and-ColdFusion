component {

    this.name = "dataTables_CF";
    this.applicationTimeout = createTimeSpan(30, 0, 0, 0); //30 days
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 0, 60, 0); // 1 hour 
    this.datasource = "cf_user";
    this.ormEnabled = false;
    this.argumentCollectionUsage = "false";
	
    // Add mapping for the models directory

    this.scriptProtect = "all";
    this.enablerobustexception  = "true";
    this.clientStorage = "cookie";
    this.serverSideFormValidation = false;
    this.enableNullSupport = true;
    this.serialization.preserveCaseForStructKey = true;
    this.serialization.preserveCaseForQueryColumn = true;
    this.timezone = "America/New_York";
    this.timeout = 20000;
    this.searchimplicitscopes = false;

    public boolean function onApplicationStart() {
       application.datasource = "cf_user";
       return true;
    }

    public void function onApplicationEnd(struct applicationScope={}) {
        return;
    }

    public void function onSessionStart() {
        return;
    } 

    public void function onSessionEnd(required struct sessionScope, struct applicationScope={}) {
        return;
    }
	public boolean function onRequestStart(required string targetPage) {
        if (structKeyExists(url,"reinit") and len(trim(url.reinit)) and (url.reinit == true) ) {
            onApplicationStart(); 
        }
		return true;
	}
	
    // function onRequest( string targetPage ) {
    //     include arguments.targetPage;
    // }

    function onRequestEnd() {}

    function onError( any Exception, string EventName ) {
        writedump(var=arguments, abort=true);
    }
    public boolean function OnMissingTemplate(required string TargetPage){
         writedump(var=arguments, abort=true);
        //Handle OnMissingTemplate Callback
        return true;
    }    

}

