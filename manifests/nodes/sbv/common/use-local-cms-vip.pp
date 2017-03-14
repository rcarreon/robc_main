# class common::use_local_cms_vip
# manifests/nodes/sbv/common/use_local_cms_vip.pp

# if dev - point to app1v-cms/media in dev ( not external prod *.springboard.com
# if stg - point to the vip-app-[media/cms] in stg
# if prd - point to vip in prd
#

# app1v-media.sbv.dev.lax.gnmedia.net 10.11.228.29
# vhosts on media are 
#  
# app1v-cms.sbv.dev.lax.gnmedia.net   10.11.228.27

class common::use_local_cms_vip {
    # 10 - dev
    # 15 - stg
    # 20 - prd
}
