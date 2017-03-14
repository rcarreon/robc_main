# these RTB API credentials are the same in all environments
class adops::dfp_rtb_creds {

    # google adx auth
    $google_adx_key = decrypt('kTS3Ugtw6rkNKhq/f6t9MDNfWGWkhazZBRBwEt+cEX3gv0QIPlFV9UW2KIY5AuXF')
    $google_adx_secret = decrypt('2tH2vCtWdKm5oEGc49Yifo7M9yFZ1g0JW9K2w1lS+0M=')

    file {'/app/shared/docroots/dfp_coordinator/config/adx_auth.ini':
        ensure  => present,
        content => template('adops/adx_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    # appnexus auth
    $appnexus_user = 'evolve_api_user'
    $appnexus_secret = decrypt('7dupvA1zDmfAjYaCUTAzRg==')

    file {'/app/shared/docroots/dfp_coordinator/config/appnexus_auth.ini':
        ensure  => present,
        content => template('adops/appnexus_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    # openx_auth
    $openx_consumer_key = decrypt('JAW3V2UKM64JV+kjGjba7OdCBU/f/57KCJHdkR7q8R0WW6pYquwsg2BfrIZkHZFi')
    $openx_consumer_secret = decrypt('1bHECaSntVMO9YwDmf1JhURkTm5451CjcecJWAasdH8XLWCFjvgd1+uEuG2ybqDm')
    $openx_consumer_realm = 'ox_op_us_realm'
    $openx_email_address  = 'ivan.perez@gorillanation.com'
    $openx_email_password = decrypt('qE2e7QDL67TUESQuQzwkGg==')

    file {'/app/shared/docroots/dfp_coordinator/config/openx_auth.ini':
        ensure  => present,
        content => template('adops/openx_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    # pubmatic auth
    $pubmatic_publisher_id = '30426'
    $pubmatic_username = 'evolveDeveloper'
    $pubmatic_password = decrypt('8M0TtMtjHv3NT0m5lxpaAw==')
    $pubmatic_api_key = decrypt('cXsmFXI7PJNIrYAmr+M5gsSHDldVXku6AGyBnTS0SFxxu2RwfuDxJnuB6UORzHAd')
    $pubmatic_key = decrypt('zlWk8HazYTYC/Nv5cHDM8m9LVplJD2rE5pPzsIfVn7iM3CK/wDrnJ13qrRfiX24V')
    $pubmatic_secret = decrypt('xlXycKekY4Zm3nK6fHM37cCBRMYKkVXa0U6ifLl/TYI=')

    file {'/app/shared/docroots/dfp_coordinator/config/pubmatic_auth.ini':
        ensure  => present,
        content => template('adops/pubmatic_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    # rubicon auth
    $rubicon_account_id = '9366'
    $rubicon_key = decrypt('PtrhyT7m+GnkBRfcSejlD7DYpjGqWPnZm9C0UgD5l1WH1XsrlAMY2gGS+dPbvUgD')
    $rubicon_secret = decrypt('1xZw9M+ToiqJMhlFhNuJCRmPOa3lQbPA8NWsMhxY5rpI2QONDoSpdQWga4PeIFWJ')

    file {'/app/shared/docroots/dfp_coordinator/config/rubicon_auth.ini':
        ensure  => present,
        content => template('adops/rubicon_auth.ini.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
