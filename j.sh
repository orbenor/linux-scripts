#!/bin/bash
echo $1
case  $1  in
                7)       
			export PATH_TEST=a
                    ;;
                8)
			export PATH_TEST=b
		    ;;            
                *)              
          esac 

