# This file is managed by Puppet do not modify it from <%= fqdn %>
# $Id$

# This block of inline C loads the library
C{

#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* (*get_country_code)(char* ip) = NULL;

__attribute__((constructor)) void
load_module()
{
    const char* symbol_name = "get_country_code";
    const char* plugin_name = "/etc/varnish/geoip_plugin.so";
    void* handle = NULL;

    handle = dlopen( plugin_name, RTLD_NOW );
    if (handle != NULL) {
        get_country_code = dlsym( handle, symbol_name );
        if (get_country_code == NULL) {
            fprintf( stderr, "\nError: Could not load GeoIP plugin:\n%s\n\n", dlerror() );
        }
        else {
            printf( "GeoIP plugin loaded successfully.\n");
        }
    }
    else {
        fprintf( stderr, "\nError: Could not load GeoIP plugin:\n%s\n\n", dlerror() );
    }
}

// Returns 1 if pre is the prefix of str. Return 0 otherwise
int
startsWith(char *pre, char *str)
{
    return (strncmp(pre, str, strlen(pre)) == 0 ? 1 : 0);
}

// Returns a pointer to the next ip address from the ip list
char *
getNextIpFromList(char *buffer, char *ipList, int size)
{
    int commaPos = size;
    char *comma;

    if (NULL == ipList) {
        ipList = "127.0.0.1";
    }

    strncpy(buffer, ipList, size);
    comma = strchr(buffer, ',');

    if (NULL != comma) {
        commaPos = comma - buffer;
    }
    if (commaPos >= size) {
        buffer[size - 1] = '\0';
    }
    else {
        buffer[commaPos] = '\0';
    }
    return strchr(ipList, ',');
}

void
getAllHeaders(struct sess *sp, char *header, char **headerValArray, int maxSize)
{
    typedef struct {
        char *contents;
        char *spacer;
    } txt;

    struct http {
        unsigned char spacer[41];
        txt *hd;
        unsigned char *hdf;
        unsigned nhd;
    };

    struct sess {
        unsigned char spacer[102];
        struct http *http;
    };

    struct sess *sp1;

    int i;
    int j = 0;
    int headerLen = strlen(header);
    char *colon;
    char *tmpHeader;

    char buffer[50];

    txt *tmpHd;
    sp1 = (struct sess *)sp;

    for (i = 0; i < sp1->http->nhd; i++) {
        tmpHeader = sp1->http->hd[i].contents;
        if (!sp1->http->hd[i].contents ||
            0 != strncmp(sp1->http->hd[i].contents, header, headerLen)) {
            continue;
        }
        colon = strchr(sp1->http->hd[i].contents, ':');
        if (NULL == colon) {
            continue;
        }
        while (colon[0] == ' ' || colon[0] == ':' ) {
            colon += 1;
        }
        headerValArray[j] = colon;
        j++;
    }
}

char *
getLocationFromIpStr(char *ipList) {
    int maxIPStrSize = 16;
    char *nextIp = ipList;
    char *country_code = NULL;
    char *unknown = "Unknown";
    char ip[maxIPStrSize];

    while (nextIp) {
        nextIp = getNextIpFromList(ip, nextIp, maxIPStrSize);
        if (NULL != nextIp) {
            while (nextIp[0] == ',' || nextIp[0] == ' ') {
                nextIp++;
            }
        }
        if (startsWith("192.168.", ip) ||
            startsWith("10.", ip) ||
            startsWith("127.0.0.1", ip)) {
            continue;
        }
        else {
            country_code = (char *)(*get_country_code)(ip);
            if (0 != strcmp(unknown, country_code)) {
                return country_code;
            }
        }
    }
    return unknown;
}

}C

