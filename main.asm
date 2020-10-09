
INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZe = 5001
.data 
;########### Messages in all project :**************
Cant_open BYTE "Cannot create file",0dh,0ah,0
Cant_open2 Byte "Cannot Open File " , 0 
Buffer_small Byte "Buffer too small of file , we nead to update buffer size at line 4 of code "
Error_read byte "Error reading file" ,0 
Message_Error byte "Cannot Open File " , 0 
invalid_credit_card byte "Failed :Invalid credit card" , 0
done_add_message byte "Credit card successfully added" , 0
debug_message byte "AHoooooooooooo" , 0 
Error_Length byte "Failed :Your Number out of Range  between 13 and 16 Digits" , 0 
Error_exist_name byte " Adding Credit card Failed :this name already exist before" , 0
Master_Visa_error byte "Failed :your number must start with 4 or 5" , 0
Hello byte "                         Welcome to the Payment System " , 0 
Choose byte "Choose : 1 to Add # :2 to Delete # :3 to Top-up credit card balance # :4 to Pay by card # :0 to Exit " , 0
Invalid_choie byte "Invalid Choice !!  please enter number from 0 to 4 " , 0  
Error_exist_number byte "Adding Credit card Failed :this number already exist before" , 0

;############################## Add messages
Enter_number byte "Please Enter your Credit Number: " , 0
Enter_expiry byte "Please Enter your Expiry Date: " , 0
Enter_Vcc byte "Please Enter your Vcc Number: " , 0
Enter_your_Name byte "Please Enter your Name: " , 0
Enter_balance byte "Please Enter your Balance: " , 0


;#############///////////////##########


;################################# Delete massages 
num_not_Exist byte "Invalid Number Not Exist" ,0 
name_not_Exist byte "Name Not Exist ",0
Done_Delete byte "Done Delete  Crdit Card ",0 
Choose_DeleteBy byte "please Choose  Search mode 1- search by Cradit number # 2- search by Name: " , 0 
Enter_credit_number byte "Enter Your Cradit number: " , 0 

enter_name  byte "Enter Cradit Card Name: " ,  0 
enter_name_note byte "Note maximum length of name 20 Character above of 20 will ignored .. " , 0


;##############################################

;############################ Pay ##################

Error_name_message byte "ERRoR... in Your Name !!",0
error_Cnum_massage byte " ERROR...The Credit Number is not correct",0
error_Date_massage byte "ERROR...Date of This Card not correct",0
error_CVV_massage byte "ERROR...Your CVV not correct",0
right_Balance_massage byte "Congratulation!!Done Your Balance Become=",0
error_Balance_massage byte "Sorry...You Don't have enough Budget  ",0

;####### to create and write in file ;***********

buffer BYTE BUFFER_SIZE DUP(?)
File_length dword 0 
buffer_length dword  0 

filename BYTE "Credit_Card_information.txt",0
fileHandle HANDLE ?

invaled_buffer_length dword 0
invaled_buffer byte 4900 dup (?) 
inva_filename_length dword 0
inva_filename BYTE "Invalid.txt",0

;###################################################	
; ####### credit Card information ;****************
; we add  maximum length by 1  , because last index add by default by null character
Credit_num byte 50 dup(?)
credit_num_length dword 0
Expiry_Date byte 6 dup (?) 
Cvv byte 4 dup (?) 
Holder_name  byte 21 dup (?) 
Holder_name_length dword 0 
Balance byte 9 dup   (?)  
Balance_length dword ? 
str_Card byte 75 dup (?)
str_Card_length dword 0  
;##########################################################
;######## checking validation data *********************
checker byte ?
sum dword 0
choice_character byte ? 


;#################################################
;######## Searching on names data *********************
Names byte 500 dup(?)
Names_length dword 0
Num_commas dword 0
found_name byte ?
;#################################################

Numbers byte 1000 dup(?)
Numbers_length dword 0
found_number byte ?
numss dword 0
;#################################################
;#################################################
;##################### Delete functions Data ;****************************
pointer_start_Record dword ? 
pointer_end_Record dword ? 
Check_exist_name dword ? ; contain 0 when not exist and 1 when exist 
check_exist_number dword ? ; contain 0 when not exist and 1 when exist 
Search_moode dword ? 
input_number byte 17 dup (?)
input_number_length dword ?

input_Name byte 22 dup (?)
input_Name_length dword ? 

Delete_Buffer byte 4900 dup (?) 
end_buffer_address dword ?   

Delete_Buffer_length dword 0 
count_comma dword 0 
buffer_offset dword ?
;####################################
PAY_str_Card  byte 75 dup(?)
PAY_str_Card_len dword 0
F_PAY_str_Card_len dword 0
F_PAY_str_Card  byte 75 dup(?)

namecoma dword 0
Pay byte 75 dup(?)
pay_length dword 0 
Expiry_Date_len dword 0
Cvv_len dword 0 

num_at dword 0
Payment_amount byte 9 Dup(?)
Payment_amount_len dword ?

Balance_amount byte 9 Dup(?)
Balance_amount_len dword ?

num_after_record dword 0

update_Buffer_length dword 0
update_Buffer byte 4900 dup (?) 
sum_B dword 0
R dword 0
Sub_pay_amount dword 0
new_balance byte 9 dup(?)
new_balance_count dword 0
line_date_len dword 0
line_cvv_len dword 0
line_card_len dword 0
line_name_len dword 0
line_date_arr byte 6 dup(?)
line_cvv_arr byte 4 dup(?)
line_card_arr byte 50 dup(?)
line_name_arr byte 50 dup(?)
name_ecx dword 0
date_ecx dword 0
card_ecx dword 0
cvv_ecx dword 0
var dword 0
;*************************************************************
 Top_Up_amount_message byte 'Enter Amount To Top UP :'
 Top_UP_amount dword 0

.code
;########################################################################## MAin Proc ;**************
main PROC

mov edx , offset Hello 
call writestring 
call crlf 

 call  load_fromFile ; to load all data file in buffer
 call load_from_invalid_File


 ;Choose_Option_Again:
 mov edx , offset Choose
 call writestring 
 call crlf 

call readint 

cmp al ,0
je Exit_program
cmp al , 1
je  Add_option 
cmp al , 2
je Delete_Option 
cmp al , 3
je Top_up_Option
cmp al , 4
je  Pay_by_credit_option 

mov edx , offset Invalid_choie 
call writestring 
call crlf 
;jmp Choose_Option_Again


Invalid_choice : mov edx , offset Invalid_choie 
call writestring 
call crlf 
;jmp Choose_Option_Again


Add_option : 

  call Input  ; Read input, set all values in varibles , and call procedure add_card 
   jmp Exit_program
 
  ;////////////////////////////////
    
 ; jmp Choose_Option_Again 
   
  Delete_Option : 
 
   ;#################################### To Choose Delete by name of number 
  mov edx , offset Choose_DeleteBy 
  call  writestring 
  call readint 

  mov Search_moode , eax 
  cmp Search_moode , 1 
  je Search_ByNumber 

  cmp Search_moode , 2 
  je Search_ByName 

  jmp Invalid_choice 

  Search_ByNumber : 

  ;######## message to declare to user enter number of crdit card 
  mov edx ,offset Enter_number 
  mov ecx , 17
  call writestring
  ;### 
  mov edx , offset input_number
    call readstring
	mov input_number_length , eax  ; ### Remmeber must cmp length between 13:16 
	; #### compare to check input between 13:16 
	cmp input_number_length , 13
	jl out_of_Range 
	cmp input_number_length , 16 
	ja out_of_Range 

 call Search_by_number ; Return 1 in check_exist_number if found , 0 if not found 
 cmp check_exist_number , 1 
 jne Not_Exist 

 call  Delete_Proc   

 mov edx , offset Done_Delete 
 call writestring 
 call crlf 


 jmp  ENd_Delete

  Not_Exist: 
   mov edx , offset num_not_Exist 
 call writestring 
 call crlf

  jmp ENd_Delete 

  Search_ByName : ; ################################################# to choose Delete by name 

  ;########## message to declare to user enter name of crdit card 

  mov edx , offset	enter_name 
  call writestring 
  call crlf 
  mov edx , offset enter_name_note
  call writestring 
  call crlf

  mov edx , offset input_Name 
  mov ecx , 22 
  call readstring 
  mov input_Name_length , eax 

  ;### append # at end of input_name , use it in Search_by_name proc 
	  mov edi , offset input_Name 
	  add edi , input_Name_length ;length based 1 
	  mov al , '#' 
	  mov [edi] , al 
	  call Search_by_name 
	  cmp Check_exist_name  , 1 ; Return 1 in check_exist_number if found , 0 if not found 
      jne Name_Not_exist2 
	  call Delete_proc

	    mov edx , offset Done_Delete 
		call writestring 
		call crlf 
       jmp ENd_Delete 

 
 Name_Not_exist2  : 
		  mov edx , offset name_not_Exist 
		 call writestring 
		 call crlf 
         jmp ENd_Delete
		  
  out_of_Range : 
			  mov edx , offset Error_length 
			  call writestring 
			  call crlf 

     ENd_Delete: 
		jmp Exit_program
   ;jmp Choose_Option_Again
   
   
   ;################################################################
   ;//////////////////////////////////////////////////////////////////  
   Top_up_Option :
		  mov edx , offset Choose_DeleteBy 
		  call  writestring 
		  call readdec 

  mov Search_moode , eax 
  cmp Search_moode , 1 
  je Top_ByNumber 

  cmp Search_moode , 2 
  je Top_ByName 

	 jmp Invalid_choice 

  Top_ByNumber : 

    ;######## message to declare to user enter number of crdit card 
		  mov edx ,offset Enter_number 
		  mov ecx , 17
		  call writestring
 
		    mov edx , offset input_number
			call readstring
			mov input_number_length , eax  ; ### Remmeber must cmp length between 13:16 

			cmp input_number_length , 13
			jl out_of_Range 
			cmp input_number_length , 16 
			ja out_of_Range 
			call Top_Up_Number
			jmp end_Top_up
           
	Top_ByName :
		mov edx , offset	enter_name 
		  call writestring 
		  call crlf 
		  mov edx , offset enter_name_note
		  call writestring 
		  call crlf

		  mov edx , offset input_Name 
		  mov ecx , 22 
		  call readstring 
		  mov input_Name_length , eax 
 
		  mov edi , offset input_Name 
		  add edi , input_Name_length ;length based 1 
		  mov al , '#' 
		  mov [edi] , al 
		 call Top_UP_name

	end_Top_up:
	jmp Exit_program
   ;################################################################
   ;jmp Choose_Option_Again 
    
   Pay_by_credit_option : 
			    call payment_input
				call Pay_Check
				jmp Exit_program

   ;jmp Choose_Option_Again  
   Exit_program : 
 
     
   
exit
main ENDP

;################################################ procedure to read input from user ;***********
Input proc 

mov edi , offset str_Card 

mov edx , offset Enter_number
mov ecx , 100
call writestring


;#####  read and concatinate credit_num at str_card ********* 
mov edx , offset credit_num
mov ecx , 50
call readstring 
 mov credit_num_length , eax

; ##################### to check that the number start with 4 or 5
 mov al , '4'
 cmp [edx] , al
 jne not4
 jmp right
 not4:
      mov al , '5'
      cmp [edx] , al
	  jne not5
right:

; ##################### to check length of number between 13 and 16 
mov ebx , 13
mov edx , 16

cmp credit_num_length , edx
ja Falsee
cmp credit_num_length , ebx 
jb Falsee

;############################ after making sure that the number of bits between 13 & 16 , now i will check about the validation
;######################## using algorithm Lughne to check number vailidation 
call check_validation
;############# return T at Checker if already Exist , and F if Not Exist 
mov al , Checker 
 cmp al, 'T'
 jne invalidd
 jmp continue


 invalidd:
 ;############ write meassage to invalid 
          mov edx , offset invalid_credit_card
		  call writestring
		  call crlf
		  jmp Done_Input

 continue:
 ;+++++++++++++++++++++++++++++++++++++++++++++=  CHECK THE UNIQUNESS OF THE NUMBER

call Searching_numbers        ;#### return F at found_number if not exist , and T if Exist 
mov al , 'F'
cmp found_number , al
jNe The_number_is_exist 
;+++++++++++++++++++++++++++++++++
mov ebp , credit_num_length 
mov esi , offset Credit_num 
add str_Card_length , ebp 
mov ecx , ebp
Credit_num_Loop : 
mov al , [esi] 
mov [edi] , al 
add esi , 1  
add edi , 1 
loop Credit_num_Loop 


;##### concatinate Delimeiter  at str_card ********* 
mov al , ','
mov [edi] , al 
add edi , 1 
;###################################################

mov edx , offset Enter_expiry
mov ecx , 100
call writestring


;#######  read and concatinate Expiry_Date  at str_card ********* 
mov edx , offset Expiry_Date 
mov ecx , 6
call readstring 


mov ecx , eax
mov esi , offset Expiry_Date 
add str_Card_length , eax 
Expiry_Date_Loop : 
mov al , [esi] 
mov [edi] , al 
add esi , 1  
add edi , 1 
loop Expiry_Date_Loop 


;####### concatinate Delimeiter  at str_card ********* 
mov al , ','
mov [edi] , al 
add edi , 1 
;######################################
;####### read and concatinate Cvv  at str_card *********

mov edx , offset Enter_Vcc
mov ecx , 100
call writestring


 
mov edx , offset Cvv  
mov ecx , 4
call readstring 


mov ecx , eax
mov esi , offset Cvv 
add str_Card_length , eax 
Cvv_Loop : 
mov al , [esi] 
mov [edi] , al 
add esi , 1  
add edi , 1 
loop Cvv_Loop 


;####### concatinate Delimeiter  at str_card ********* 
mov al , ','
mov [edi] , al 
add edi , 1 

;#################################################################
;####### read  and concatinate Holder_name  at str_card *********

mov edx , offset Enter_your_name
mov ecx , 100
call writestring

mov edx , offset Holder_name 
mov ecx , 21
call readstring 
mov Holder_name_length , eax
;########## check about the name it is already exist

;##########################

call Searching_names          
mov al , 'F'
cmp found_name , al
jNe The_name_is_exist 
;############################

mov eax , Holder_name_length 
mov ecx , eax                             
mov esi , offset Holder_name
add str_Card_length , eax 
Holder_name_Loop : 
mov al , [esi] 
mov [edi] , al 
add esi , 1  
add edi , 1 
loop Holder_name_Loop  

;####### concatinate Delimeiter  at str_card ********* 
mov al , ','
mov [edi] , al 
add edi , 1 

;################################################################################

;####### read and concatinate Balance  at str_card *********

mov edx , offset Enter_balance
mov ecx , 100
call writestring


 
mov edx , offset balance 
mov ecx , 9
call readstring 

mov ecx , eax
mov esi , offset Balance 
add str_Card_length , eax 
Balance_Loop : 
mov al , [esi] 
mov [edi] , al 
add esi , 1  
add edi , 1 
loop Balance_Loop 

;####### concatinate Delimeiter  at  end of str_card  ********* 
mov al , '@'
mov [edi] , al 
add edi , 1 

add str_Card_length , 5


;############## calling add card
; ########### take string str_card  and concatinate it with buffer 
call Add_Card


jmp Done_Input 

Falsee : 
;########### write message when invaild input 
mov edx  , offset Error_Length
call writestring 
call crlf
jmp Done_Input

not5:
;##### message when cratit number doesn't start with 4 or 5 

                  mov edx , offset Master_Visa_error
				  call writestring
				  call crlf
				  jmp Done_Input
The_name_is_exist:
                  mov edx , offset Error_exist_name
				  call writestring
				  call crlf
				  jmp Done_Input

The_number_is_exist:
                     mov edx , offset Error_exist_number
					 call writestring
					 call crlf 
                    				   
Done_Input :

                  mov eax , ' ' 
				  mov str_card , al 
				  mov eax , 0 
				  mov str_Card_length , eax
ret
inPUt endp


;############################################################# ADD Card procedure :***********************
Add_Card proc 

mov esi , offset buffer
add esi , File_length ; to mov esi at end of buffer and ready to concatinate 
mov edi , offset str_Card
mov ecx , str_Card_length
add  buffer_length , ecx ; 

transfer_to_buffer:
                   mov  al , [edi]
				   mov [esi] , al
				   inc edi
				   inc esi
loop transfer_to_buffer
 call Save_ToFile ; ###### save buffer in file 

  mov edx , offset done_add_message
		  call writestring 
		  call crlf
done_add:
ret
Add_Card endp

;###############################################################################

;#################################################### procedure to save buffer in file :****************** 
comment @ ;#########################

this function take buffer and save it in file , 
and check about errors in open file  by using File handle  @ 


Save_ToFile proc 
mov edx,OFFSET filename
call CreateOutputFile

mov fileHandle,eax 

; Check for errors.
cmp eax, INVALID_HANDLE_VALUE ; error found?
jne file_ok ; no: skip
mov edx,OFFSET Message_Error ; display error
call WriteString
jmp quit
file_ok:
mov eax,fileHandle
; offset of bufer , note buffer contain all file and str_card 
mov edx,OFFSET buffer
mov ecx,buffer_length
call WriteToFile


call CloseFile
quit : 
ret 
Save_ToFile endp


;###################################################
;###################################### load form file in buffer : *******************

; retrive all file and set it in buffer string 

load_fromFile proc 

mov edx,OFFSET filename
call OpenInputFile
mov fileHandle,eax
cmp eax,INVALID_HANDLE_VALUE ; error opening file?
jne file_ok ; no: skip
mov edx , offset Cant_open2 
call writestring 

jmp quit ; and quit
file_ok:

; ########### when read from file ,the actual size of file set in eax , so we need to check  
; 1 - find problem in read , 2- buffer size enough to read file  

mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile

; ######## Check one  
 ;######### when set carry flag by one which mean an error occur occur
jnc check_buffer_size

 ;#### message error read 
mov edx ,offset Error_read 
call writestring 
jmp close_file

check_buffer_size:

cmp eax,BUFFER_SIZE ; buffer large enough?
jb buf_size_ok ; yes enough so jump now 

mov edx , offset Buffer_small
call writestring


jmp quit ; and quit

buf_size_ok:
;mov buffer[eax],0 ; insert null terminator

add File_length, eax 
add buffer_length , eax 

close_file :
mov eax,fileHandle
call CloseFile
quit: 

ret

load_fromFile endp 


;################################################################### check validation function
;####  appling lughne Algorithm 
check_validation proc

mov sum , 0
mov esi , 0
mov ecx , credit_num_length

mov edx , offset Credit_num
add edx , ecx
sub edx , 2

L1 :

mov bl , [edx]
sub bl , 48
add bl , bl

cmp bl , 9
ja C1
movzx esi , bl
add sum , esi
jmp next

C1 :
sub bl , 9
movzx esi , bl
add sum , esi


next : sub edx , 2
sub ecx , 1

cmp ecx , 0
je H0

Loop L1

H0 : mov edx , 0
mov bx , 10
mov eax , sum
div bx

cmp edx , 0
je C3
Falsee : 
mov al , 'F'
mov checker , al
jmp H1

C3 :
mov al , 'T'
mov checker , al

H1 : 



ret 
check_validation endp


;###############################################################################

;/////////////////////////////////////////////////////////////////////////////
;#################################################
comment @ this function load all the Holder names from the file and set it in array names 
and check about the input_name if exist  or not in file 
and return T  in found_name if already exist  and F if not Exist @ 

;########################### 



Searching_names proc  ;################# function search if the name already exist or not

mov ebx , offset buffer
mov esi , offset Names

mov ecx , buffer_length

Get_names:             ; ############ this loop load the names from buffer to Names array
   mov al , [ebx]
   cmp al , ','
   je found
   jmp skip
   found:
         add Num_commas , 1
		 mov eax , Num_commas
		 cmp eax , 3
		 je found3
		 jmp skip
		 found3:
				 inc ebx
				 sub ecx , 1
				 inner:
				            mov al , ','
							cmp [ebx] , al
							je break
							mov al , [ebx]
							mov [esi] , al
							inc Names_length
							inc ebx
							sub ecx , 1
							inc esi
							
				  jmp inner
                      break:
					  mov al , ','
					  mov [esi] , al 
					  inc Names_length
					  inc esi
					  mov Num_commas , 0
   skip:
        inc ebx
		;cmp ecx , 0 
		;je eeeeennnddd
loop Get_names
eeeeennnddd :

;#####################################################################
 
mov ebx , offset Names
mov esi , offset Holder_name
mov ebp , 0
mov ecx , Names_length

Existing_name:                 ; Searching on names if this HolderName allready exist before
               mov al , ','
			   cmp [ebx] , al
			   je follow
			   mov al , [ebx]
			   cmp al , [esi]
			   jne follow
			   inc ebp
			   cmp ebp , Holder_name_length
			   je matched
		       inc ebx
			   inc esi
			   jmp skipp

			   follow:
			          inc ebx
					  mov ebp , 0
					  mov esi , offset Holder_name 

      skipp:
	           
loop Existing_name

mov found_name , 'F'
jmp doneee
matched:
        mov found_name , 'T'

	doneee:
	     
ret
Searching_names endp
;################################################################££££££££££££££££££££££££££££££


;#################################################
comment @ this function load all the Cradit Numbers  from the file and set it in array Numbers 
and check about the input_number if exist  or not in file 
and return T  in found_number if already exist  and F if not Exist @ 

;########################### 


Searching_numbers proc

mov ebx , offset buffer
mov esi , offset Numbers

mov ecx , buffer_length

Get_Numbers:
          againn: cmp ecx , 0
		         je outt   
		     mov al , ','
			 cmp [ebx] , al
			 je steb1
			 mov al , [ebx]
			 mov [esi] , al
			 inc Numbers_length
			 jmp skeb
			 steb1:
			       mov al , ','
				   mov [esi] , al
				   inc Numbers_length
		steb2:     inc ebx
				   sub ecx , 1
				   mov al , '@'
				   cmp [ebx] , al
				   je again 
			       jmp steb2
			       again: inc ebx
				          sub ecx , 1
						  inc esi
						  ;inc Numbers_length
						  jmp againn
			 skeb: 
			       inc esi 
				   inc ebx
loop Get_Numbers

outt:

;//////////////////////////////////////////////////////////////


mov ebx , offset Numbers
mov esi , offset Credit_num
mov ebp , 0
mov ecx , Numbers_length

Existing_number:                 ; Searching on numbers if this CreditNumber allready exist before
               mov al , ','
			   cmp [ebx] , al
			   je followw
			   mov al , [ebx]
			   cmp al , [esi]
			   jne followw
			   inc ebp
			   cmp ebp , credit_num_length
			   je matchedd
		       inc ebx
			   inc esi
			   jmp skipps

			   followw:
			          inc ebx
					  mov ebp , 0
					  mov esi , offset credit_num
      skipps:
	           
loop Existing_number

mov found_number , 'F'
jmp barca
matchedd:
        inc ebx
		mov al , ','
		cmp [ebx] , al
		jne not_equal
        mov found_number , 'T'
		jmp barca
	not_equal:
	          mov found_number , 'F'

			  barca:


ret
Searching_numbers endp 


;//////////////////////////////////////DELETE OPTION ///////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////


;############################################################# DElete functions 


	Search_by_number proc 

	mov esi , offset buffer 

	mov edi , offset input_number

	mov ecx , buffer_length 
	
	Check_Loop : 

	mov al , [esi] 
	cmp al , [edi] 
	je continou 

	not_equl : 
	
	mov al, [esi]  ; ascci number of character comma = 44 
	cmp al , ','
	je Exist

	 cmp ecx , 0 
	 jle end_not_exist 

	Faild : 
	sub ecx , 1 

	add esi , 1 

	mov al , '@' ; assci number for @ equal 64 
	mov bl,  [esi]

	cmp bl , al
		je end_inner

		 cmp ecx , 0 
	 jle end_not_exist 

	jmp faild

	end_inner : 
	mov edi , offset input_number ;### mov edi at begin of input number to check again in new Record 
	add esi  , 1 ;### to equal first digit in new Recorf 
	 jmp continou2    ;not continou to not incremnt esi and edi  

	Exist : 
 mov pointer_start_Record  , esi ; offset of comma after name exist 
 mov ebx ,  1
	mov check_exist_number , ebx 
		jmp	end_Exist

continou :							
add esi , 1 
add edi , 1 
continou2: 
 loop Check_Loop 

;when end loop and not jmp at end_Exist which mean number not exist , so set check_exist_number by 0 and end prc
	mov ebx ,  0 
	mov check_exist_number , ebx 
	jmp end_not_exist 

	end_Exist : 

	mov edx , pointer_start_Record 
	sub edx , input_number_length 
	mov pointer_start_Record , edx 
	
	;##### this loop to find pointer_end_Record
	find_end_record : 
	add esi , 1 
	mov al , '@' 
	cmp al , [esi] 
	je find_end 
	jmp find_end_record  

	find_end : 
	mov pointer_end_Record , esi 
	end_not_exist : 
	ret 
	Search_by_number endp 
	;###################################################################### Search by name ProC 

	Search_by_name proc
	mov esi , offset buffer 
	mov edi , offset input_Name 
	mov ecx , buffer_length 
	search_loop :
	mov al , ',' 
	cmp [esi] , al 
	jne Continou1 
	add count_comma  ,1 

	cmp count_comma  , 3 
	jne Continou1 
	;############### now start Check name , and reset number of comma 
	mov count_comma , 0 
	mov edi , offset input_Name
	
	Check_Name_loop :
	add esi , 1 
	mov al , [esi] 
	cmp al , [edi] 
	jne Notmatch 
	add edi ,1 
	sub ecx , 1
	 jmp Check_Name_loop

	 Notmatch : 
	 mov al , [esi] 
	 cmp al , ',' 
	 jne Continoue_until@ 
	 mov al , [edi] 
	 cmp al , '#' 
	 je End_Exist_name

	 Continoue_until@ : 
	 add esi , 1 
	 cmp esi , end_buffer_address
	 je End_Not_Exist_name

	 mov al , [esi] 
	 cmp al , '@' 
	 je Continou1 

	 sub ecx , 1 
	jmp  Continoue_until@ 

	

	Continou1 : 
	add esi , 1 

	 cmp esi , end_buffer_address
	 je End_Not_Exist_name

	 cmp ecx , 0 
	 jle End_Not_Exist_name 

	loop search_loop

	jmp End_Not_Exist_name 
		
		End_Exist_name:  
		mov buffer_offset , offset buffer

		mov ebx , 1 
		mov Check_exist_name  , ebx 
		;#### now loop to retrive start index 
	;{ 
	strat_pointer_loop : 

		mov al , [esi] 
		cmp al , '@' 
		je end_strat_pointer_loop
		sub esi , 1 

		cmp esi , buffer_offset
		je First_Record 

		jmp strat_pointer_loop 
		  
		end_strat_pointer_loop : ; }

		add esi , 1  ; first char in record 
		First_Record : 
		mov pointer_start_Record , esi 

	end_pointer_loop :
	add esi , 1 
	mov al , '@' 
	cmp [esi] , al 
	je end_end_pointer_loop

	jmp end_pointer_loop 

	end_end_pointer_loop:
	mov pointer_end_Record  , esi 
		;########
		jmp ENdd_search 

	End_Not_Exist_name:
	mov ebx , 0
		mov Check_exist_name  , ebx 



	ENdd_search : 
	ret
	Search_by_name endp 

	;###################################################################
;##############
comment @ Delete proc get start , end pointer of record want to delete it  ,
 and add all records  in delete buffer except record want to delete it then write delete buffer in file @ 
 ; ########################
	Delete_Proc proc 
	mov edi , offset Delete_Buffer 

mov esi , offset buffer 
;##################### to save last address of buffer , using in second loop 
mov end_buffer_address , esi 
mov eax , buffer_length
add end_buffer_address ,  eax 

set_Records_before  : 
cmp esi , pointer_start_Record 
je End_set_before 
add Delete_Buffer_length , 1
mov al , [esi] 
mov [edi] , al 
add esi ,1 
add edi , 1 
jmp set_Records_before 
End_set_before : 


mov esi , pointer_end_Record

Set_Records_after :
cmp esi , end_buffer_address 
je End_set_after
add esi , 1 
mov al , [esi] 
mov [edi] , al
add edi ,1 
add Delete_Buffer_length , 1
jmp Set_Records_after
End_set_after : 
sub Delete_Buffer_length , 1
call  Save_ToFile_after_delete 


ret

	Delete_Proc endp 


	Save_ToFile_after_delete proc 

mov edx,OFFSET filename
call CreateOutputFile

mov fileHandle,eax 

; Check for errors.
cmp eax, INVALID_HANDLE_VALUE ; error found?
jne file_ok ; no: skip
mov edx,OFFSET Message_Error ; display error
call WriteString
jmp quit
file_ok:
mov eax,fileHandle
; offset of bufer , note buffer contain all file and str_card 
mov edx,OFFSET Delete_Buffer
mov ecx,Delete_Buffer_length
call WriteToFile


call CloseFile
quit : 
ret 
Save_ToFile_after_delete endp
;######################################### Top_UP Card ######################################################

;*********************************************************************
;this function use search by number to ensure if card_number found or not
;this will return "Line" with new balance and save it in file 
;*********************************************************************
Top_UP_number proc
		call Search_by_number
		cmp check_exist_number , 1 
        jne Not_Exist_num 
			mov edx,offset Top_Up_amount_message
			call writestring 
			call readdec
			mov  Top_Up_amount,eax
			 call sum_amount
			jmp end_num
		
		 Not_Exist_num: 
			 mov edx , offset num_not_Exist 
			 call writestring 
			 call crlf
	 end_num:

 ret
Top_UP_number Endp
;*********************************************************************
;this function use search by number to ensure if card_name found or not
;this will return "Line" with new balance and save it in file 
;*********************************************************************
Top_UP_name proc
		call Search_by_name
		cmp check_exist_name , 1 
        jne Not_Exist_name 
			mov edx,offset Top_Up_amount_message
			call writestring 
			call readdec
			mov  Top_Up_amount,eax
			 call sum_amount
			 jmp end_name
			
		 Not_Exist_name: 
			 mov edx , offset name_not_Exist 
			 call writestring 
			 call crlf
		end_name:

 ret
Top_UP_name Endp

;********************************************************
;this proc to Sum more money from Balance to integer
;return arr of byte "new_balance" contain user_balane after Subtract
;and save new_balance in file
;*****************************************************
sum_amount proc
    call cut_line
	call Calc_balane

	mov edi, sum_B
	add edi,Top_UP_amount

;****************************convert integer "Sub_pay_amount" to byte***************************
    mov eax, edi    ; number to be converted
    mov ecx, 10         ; divisor
    xor bx, bx          ; count digits
	mov new_balance_count,0
divide:
    xor edx, edx        ; high part = 0
    div ecx             ; eax = edx:eax/ecx, edx = remainder
    push dx             ; DL is a digit in range [0..9]
    inc bx              ; count digits
    test eax, eax       ; EAX is 0?
    jnz divide          ; no, continue

    ; POP digits from stack in reverse order
    mov cx, bx          ; number of digits
   lea si, new_balance   ; DS:SI points to string buffer
next_digit:
		pop ax
		add al, '0'         ; convert to ASCII
		mov [esi], al        ; write it to the buffer
		inc new_balance_count
		inc si
    loop next_digit
  ;*************************************************************
	 mov edx,offset right_Balance_massage
	 call writestring
	 mov eax, edi
	 call writedec
	 call crlf

	 call Update_record  ; call it to save new record in file
	 
	 Y:
	 mov edi,0
	 mov sum_B,0
	 mov Top_UP_amount,0
	 ret
sum_amount endp

;##################################`Pay by credit card functions ###########################################

;**********************************************************
;this proc read date from user and make it as a record in file :" PAY_str_Card " 
;***************************************************************
Payment_Input PROC

		mov edi , offset PAY_str_Card 
		mov edx , offset Enter_number
		mov ecx , lengthof   Enter_number
		call writestring


		;#####  read and concatinate credit_num at str_card ********* 
		mov edx , offset credit_num
		mov ecx , 50
		call readstring 


		mov ecx , eax 
		mov credit_num_length , eax
		mov ebp , eax
		; ##################### to check that the number start with 4 or 5
		 mov al , '4'
		 cmp [edx] , al
		 jne not4
		 jmp right
		 not4:
			  mov al , '5'
			  cmp [edx] , al
			  jne not5
		right:

		; ##################### to check length of number between 13 and 16 
		mov ebx , 13
		mov edx , 16

		cmp credit_num_length , edx
		ja Falsee

		cmp credit_num_length , ebx 
		jb Falsee

		mov esi , offset Credit_num 
		add PAY_str_Card_len , ebp 
		mov ecx , ebp
			Credit_num_Loop : 
						mov al , [esi] 
						mov [edi] , al 
						add esi , 1  
						add edi , 1 
			loop Credit_num_Loop 

		;##### concatinate Delimeiter  at str_card ********* 
		mov al , ','
		mov [edi] , al 
		add edi , 1 
		;###################################################


		;#######  read and concatinate Expiry_Date  at str_card ********* 
		mov edx , offset Enter_expiry
		mov ecx , lengthof  Enter_expiry
		call writestring

		mov edx , offset Expiry_Date 
		mov ecx , 6
		call readstring 

		mov Expiry_Date_len,eax
		mov ecx , eax
		mov esi , offset Expiry_Date 
		add  PAY_str_Card_len , eax 
			Expiry_Date_Loop : 
					mov al , [esi] 
					mov [edi] , al 
					add esi , 1  
					add edi , 1 
			loop Expiry_Date_Loop 


		;####### concatinate Delimeiter  at str_card ********* 
		mov al , ','
		mov [edi] , al 
		add edi , 1 
		;######################################
		;####### read and concatinate Cvv  at str_card ********* 
		mov edx , offset Enter_Vcc
		mov ecx , lengthof  Enter_Vcc
		call writestring

		mov edx , offset Cvv  
		mov ecx , 4
		call readstring 


		mov Cvv_len , eax
		mov ecx , eax
		mov esi , offset Cvv 
		add  PAY_str_Card_len , eax 
		Cvv_Loop : 
				mov al , [esi] 
				mov [edi] , al 
				add esi , 1  
				add edi , 1 
		loop Cvv_Loop 


		;####### concatinate Delimeiter  at str_card ********* 
		mov al , ','
		mov [edi] , al 
		add edi , 1 

		;#################################################################
		;####### read  and concatinate Holder_name  at str_card ********* 
		mov edx , offset Enter_your_name
		mov ecx , lengthof  Enter_your_name
		call writestring

		mov edx , offset Holder_name 
		mov ecx , 21
		call readstring 

		mov Holder_name_length , eax
		mov ecx , eax
		mov Holder_name_length , eax
		mov esi , offset Holder_name
		add  PAY_str_Card_len , eax 
			Holder_name_Loop : 
						mov al , [esi] 
						mov [edi] , al 
						add esi , 1  
						add edi , 1 
			loop Holder_name_Loop  

		;####### concatinate Delimeiter  at str_card ********* 
		mov al , ','
		mov [edi] , al 
		add edi , 1 

		;####### read and concatinate Balance  at str_card ********* 
		mov edx , offset Enter_balance
		mov ecx , lengthof  Enter_balance
		call writestring

		mov edx , offset Payment_amount
		mov ecx , 9
		call readstring 
		mov Payment_amount_len,eax

		mov ecx , eax
		mov esi , offset Payment_amount
		add  PAY_str_Card_len, eax 
			Balance_Loop : 

						mov al , [esi] 
						mov [edi] , al 
						add esi , 1  
						add edi , 1 

			loop Balance_Loop 

		;####### concatinate Delimeiter  at  end of str_card  ********* 
		mov al , '@'
		mov [edi] , al 
		add edi , 1 
		jmp Done_Input 

		Falsee : 
					mov edx , offset Error_Length
					call writestring 
					call crlf
					jmp Done_Input

		not5:
				    mov edx , offset Master_Visa_error
					call writestring
					call crlf
					jmp Done_Input
		Done_Input :

		add  PAY_str_Card_len , 5

		ret
Payment_Input endp
;**********************************************************************************
Search_by_name_update proc

	mov esi , offset buffer 
	mov edi , offset Holder_name
	mov ecx , buffer_length 
	search_loop :
	mov al , ',' 
	cmp [esi] , al 
	jne Continou1 
	add count_comma  ,1 

	cmp count_comma  , 3 
	jne Continou1 
	;############### now start Check name , and reset number of comma 
	mov count_comma , 0 
	mov edi , offset Holder_name
	
	Check_Name_loop :
	add esi , 1 
	mov al , [esi] 
	cmp al , [edi] 
	jne Notmatch 
	add edi ,1 
	sub ecx , 1
	 jmp Check_Name_loop

	 Notmatch : 
	 mov al , [esi] 
	 cmp al , ',' 
	 jne Continoue_until@ 
	 mov al , [edi] 
	 cmp al , '#' 
	 je End_Exist_name

	 Continoue_until@ : 
	 add esi , 1 
	 cmp esi , end_buffer_address
	 je End_Not_Exist_name

	 mov al , [esi] 
	 cmp al , '@' 
	 je Continou1 

	sub ecx , 1 
	jmp  Continoue_until@ 

	

	Continou1 : 
	add esi , 1 

	 cmp esi , end_buffer_address
	 je End_Not_Exist_name

	 cmp ecx , 0 
	 jle End_Not_Exist_name 

	loop search_loop

	jmp End_Not_Exist_name 
		
		End_Exist_name:  
		mov buffer_offset , offset buffer

		mov ebx , 1 
		mov Check_exist_name  , ebx 
		;#### now loop to retrive start index 
	;{ 
	strat_pointer_loop : 

		mov al , [esi] 
		cmp al , '@' 
		je end_strat_pointer_loop
		sub esi , 1 

		cmp esi , buffer_offset
		je First_Record 

		jmp strat_pointer_loop 
		  
		end_strat_pointer_loop : 
		; }

		add esi , 1  ; first char in record 
		First_Record : 
		mov pointer_start_Record , esi 

	end_pointer_loop :
	add esi , 1 
	mov al , '@' 
	cmp [esi] , al 
	je end_end_pointer_loop

	jmp end_pointer_loop 

	end_end_pointer_loop:
	mov pointer_end_Record  , esi 
		;########
		jmp ENdd_search 

	End_Not_Exist_name:
	    mov ebx , 0
		mov Check_exist_name  , ebx 



	ENdd_search : 
	ret
	Search_by_name_update endp 
;********************************************************************
;this function will check if this name in file or not
;if True compare data from user with record in file
;else show error messege
;*****************************************
Pay_Check PROC
 
 mov edi , offset Holder_name 
  add edi , Holder_name_length ; length based 1 
  mov al , '#' 
  mov [edi] , al 
  ;############## 
  call Search_by_name_update

			 cmp Check_exist_name  , 1 
			 je equl

					 mov edx,offset Error_name_message
					 call writestring
					  call crlf
					  call Write_Invalid 
					 jmp next
			 equl:
					call comp_record
			 next:
 ret
Pay_Check Endp
;*********************************************
; this get record in array of byte "Pay" from file after search with name
;**************************************************
Get_line2 proc 
    

	        mov ebx , offset buffer
			mov esi , offset Pay
			mov ecx , buffer_length
 Get_start:
			cmp ebx,pointer_start_Record
			jne skip_Record
			mov ecx,100
		LooP_Record:
			 mov al,[ebx]
			 mov [esi],al
			 inc esi
			 inc ebx
			 inc pay_length
			cmp ebx,pointer_end_Record
			je out_record
		Loop LooP_Record

	  skip_Record:
				inc ebx
	 Loop Get_start
out_record:
ret
Get_line2 Endp 




;************************************************
; this function compare two record if true call another function 
;to sub balance else return error message
;*************************************************
comp_record proc

  call Cut_line
 mov ebx , offset line_card_arr
 mov esi , offset Credit_num
 mov ecx ,credit_num_length
 cmp ecx,line_card_len
  jne error_num

 Existing_card:                 ;this loop To check Card number for this name equl user input
           ;{ 
			   mov al , [ebx]
			   cmp al , [esi]
			   jne follow
		       inc ebx
			   inc esi
			   jmp skipp_card

			   follow:
			          mov ecx,1
					  jmp error_num	 	

      skipp_card:
	           
loop Existing_card   ;}

	mov ebx , offset line_date_arr
	mov esi , offset  Expiry_Date
	mov ecx , Expiry_Date_len
	cmp ecx,line_date_len
    jne error_Date
Existing_Date:                 ; ;this loop To check Date for this name equl user input
         ;{  
			   mov al , [ebx]
			   cmp al , [esi]
			   jne follow_D
		       inc ebx
			   inc esi

			   jmp skipp_Date

			   follow_D:
			          mov ecx,1
					   jmp error_Date	 	

      skipp_Date:
	           
loop Existing_Date ;}
		
		mov ebx , offset line_cvv_arr
		mov esi , offset  Cvv
		mov ecx , Cvv_len 
		cmp ecx,line_cvv_len
		 jne error_CVV

Existing_CVV:                 ; ;this loop To check if CVV for this name equl user input
      ;{
			   mov al , [ebx]
			   cmp al , [esi]
			   jne follow_C
		       inc ebx
			   inc esi
			   jmp skipp_cvv

			   follow_C:
			          mov ecx,1
					   jmp error_CVV	 	

      skipp_cvv:
	           
loop Existing_CVV  ;}

jmp matched_Balance  ;jmp to check balance if all date equal

error_num:
		mov edx,offset error_Cnum_massage
		call writestring
		call crlf
		call Write_Invalid
		jmp X 

error_Date:
		mov edx,offset error_Date_massage
		call writestring
		call crlf
		call Write_Invalid
		jmp X

error_cvv:
		mov edx,offset error_CVV_massage
		call writestring
		call crlf
		call Write_Invalid
		jmp X
error_Balance:
		mov edx,offset error_Balance_massage
		call writestring
		 call Write_Invalid
		call crlf
		jmp X
matched_Balance:
		call calc_Payment_amount
		call Calc_balane
		call Sub_balane
		
		
	X:
ret
comp_record endp
;********************************************************
;this proc to convert user_pay to integer
;return  dword number "Sub_pay_amount"
;*****************************************************
calc_Payment_amount proc

mov edx , offset Payment_amount
mov edi,Payment_amount_len
mov ecx,Payment_amount_len
mov Sub_pay_amount,0
mov R,0
mov eax,0
mov edx,0
	L3:
	    mov ebx,ecx
		mov edi,ecx
		sub edi,1

		mov al,Payment_amount[edx]
		sub al,'0'

		mov ecx,edi
		cmp ecx,0
		je next3
		
		L4:
			mov si,10
			mul si
		Loop L4

		add Sub_pay_amount ,eax

		jmp n

		next3:
			add Sub_pay_amount,eax
		n:
			mov ecx,ebx
			inc R
			mov edx,R
		    mov eax,0
		
	Loop L3
ret
calc_Payment_amount endp
;********************************************************
;this proc to convert Balance to integer
;return  dword number "sum_B"
;*****************************************************

Calc_balane proc

	mov edx , offset Balance_amount
	mov sum_B,0
	mov edi,Balance_amount_len
	mov ecx,Balance_amount_len
	mov eax,0
	mov edx,0
	mov R,0
		L_B:
				mov ebx,ecx

				mov edi,ecx
				sub edi,1

			mov al,Balance_amount[edx]
			sub al,'0'

			mov ecx,edi
			cmp ecx,0
			je next_B
		
			L4_B:
				mov si,10
				mul si
			Loop L4_B

			add sum_B,eax
		
			jmp n

			next_B:
				add sum_B,eax
			n:
				mov ecx,ebx
				inc R
				mov edx,R
				mov eax,0
		
			Loop L_B
	ret
Calc_balane endp
;********************************************************
;this proc to Sub user_paied from Balance to integer
;return arr of byte "new_balance" contain user_balane after Subtract
;and save new_balance in file
;*****************************************************
 Sub_balane proc

mov edi, sum_B
cmp edi,Sub_pay_amount
jNB Sub_amount
mov edx,offset error_Balance_massage 

call writestring
call crlf
call Write_Invalid

jmp Y

Sub_amount:
	sub edi,Sub_pay_amount
;****************************convert integer "Sub_pay_amount" to byte***************************
    mov eax, edi    ; number to be converted
    mov ecx, 10         ; divisor
    xor bx, bx          ; count digits
	mov new_balance_count,0
divide:
    xor edx, edx        ; high part = 0
    div ecx             ; eax = edx:eax/ecx, edx = remainder
    push dx             ; DL is a digit in range [0..9]
    inc bx              ; count digits
    test eax, eax       ; EAX is 0?
    jnz divide          ; no, continue

    ; POP digits from stack in reverse order
    mov cx, bx          ; number of digits
   lea si, new_balance   ; DS:SI points to string buffer
next_digit:
		pop ax
		add al, '0'         ; convert to ASCII
		mov [esi], al        ; write it to the buffer
		inc new_balance_count
		inc si
    loop next_digit
;*************************************************************
	 mov edx,offset right_Balance_massage
	 call writestring
	 mov eax, edi
	 call writedec
	 call crlf
	 call Update_record  ; call it to save new value in file
	 
	 Y:
	 mov edi,0
	 mov sum_B,0
	 mov Sub_pay_amount,0
	 ret
 Sub_balane endp
;********************************************************
;Make new record with balance after subtact paid fom it
;********************************************************
Payment_final PROC

			mov edi , offset F_PAY_str_Card 
			mov F_PAY_str_Card_len,0
	;#####  read and concatinate credit_num at str_card ********* 

			mov ebp , line_card_len
			mov esi , offset line_card_arr
			add F_PAY_str_Card_len , ebp 
			mov ecx , ebp
			 Credit_num_Loop : 
					mov al , [esi] 
					mov [edi] , al 
					add esi , 1  
					add edi , 1 
			 loop Credit_num_Loop 

	;##### concatinate Delimeiter  at str_card ********* 
			mov al , ','
			mov [edi] , al 
			add edi , 1 
			
	;#######  read and concatinate Expiry_Date  at str_card ********* 
			mov eax,line_date_len
			mov ecx , line_date_len
			mov esi , offset line_date_arr 
			add  F_PAY_str_Card_len , eax 
			 Expiry_Date_Loop : 
					mov al , [esi] 
					mov [edi] , al 
					add esi , 1  
					add edi , 1 
			 loop Expiry_Date_Loop 


	;####### concatinate Delimeiter  at str_card ********* 
			mov al , ','
			mov [edi] , al 
			add edi , 1

	;####### read and concatinate Cvv  at str_card ********* 
			mov eax,line_cvv_len
			mov ecx , line_cvv_len
			mov esi , offset line_cvv_arr 
			add  F_PAY_str_Card_len , eax 
			Cvv_Loop : 
					mov al , [esi] 
					mov [edi] , al 
					add esi , 1  
					add edi , 1 
			loop Cvv_Loop 

  ;####### concatinate Delimeiter  at str_card ********* 
			mov al , ','
			mov [edi] , al 
			add edi , 1 

   ;####### read  and concatinate Holder_name  at str_card ********* 
			mov eax,line_name_len
			mov ecx ,  line_name_len
			;mov line_name_len , eax
			mov esi , offset line_name_arr
			add  F_PAY_str_Card_len , eax 
				Holder_name_Loop : 
						mov al , [esi] 
						mov [edi] , al 
						add esi , 1  
						add edi , 1 
				loop Holder_name_Loop  

  ;####### concatinate Delimeiter  at str_card ********* 
			mov al , ','
			mov [edi] , al 
			add edi , 1 

	;####### read and concatinate Balance  at str_card ********* 
			mov ecx , new_balance_count
			mov esi , offset new_balance
			mov eax,new_balance_count
			add F_PAY_str_Card_len, eax 

			  Balance_Loop : 
						mov al , [esi] 
						mov [edi] , al 
						add esi , 1  
						add edi , 1 
			   loop Balance_Loop 

	;####### concatinate Delimeiter  at  end of str_card  ********* 
				mov al , '@'
				mov [edi] , al 
				add edi , 1 

		add  F_PAY_str_Card_len , 5
ret
Payment_final endp

;***********************************************************************
;this return a update_buffer with newrecord and save it in file
;**********************************************************************
Update_record proc
		call Payment_final    ;call in to load new record in array "pay"

	 mov ebx ,offset update_Buffer  
	 mov edx, offset buffer

	 mov ecx,buffer_length		;this loop move date before "record" in new buffer

	Move_before:
	       cmp edx, pointer_start_Record
		   je new_record
		   mov al,[edx]
		   mov[ebx],al
		   inc edx
		   inc ebx
	   	   inc update_Buffer_length 
	 Loop Move_before

	new_record:
	;sub ecx,1
	mov num_after_record,ecx        ;this save length after i move  date before record
	
		mov esi ,offset F_PAY_str_Card
		mov ecx,F_PAY_str_Card_len

	move_record:					  ;this record move new record in update_buffer
			mov al,[esi]
			mov [ebx],al
			inc ebx
			inc esi
			inc update_Buffer_length
	 Loop move_record

		add edx,pay_length
		inc edx

		mov edi,num_after_record
		sub edi,pay_length
		sub edi,1

		
		mov ecx,0
		cmp edi,ecx
		je next_save
		
	
	mov ecx,edi
	move_after:							;this loop to move data after record in updated_buffer
		
			mov al,[edx]
			mov [ebx],al
			inc edx
			inc ebx
			inc update_Buffer_length


loop move_after

	next_save:
	call Save_ToFile_after_update      ;call to save updatte_buffer in file

ret
Update_record endp

;********************************************************************
; this function save Buffer after update in the file
;***************************************************************
Save_ToFile_after_update proc 

		mov edx,OFFSET filename
		call CreateOutputFile
		

		mov fileHandle,eax 

		; Check for errors.
		cmp eax, INVALID_HANDLE_VALUE     ; error found?
		jne file_ok ; no: skip
		mov edx,OFFSET Message_Error      ; display error
		call WriteString
		jmp quit
		file_ok:
		mov eax,fileHandle

		;**offset of bufer , note buffer contain all file with update

		mov edx,OFFSET update_Buffer
		mov ecx,update_Buffer_length
		call WriteToFile
		call CloseFile
	quit : 
ret 
Save_ToFile_after_update endp
;*************************************************************************************
; this function take array of byte "pay" this containt data of this user in file"before update"
; and return every part in new array of byte
; line_card_arr		"contain card_num"
;line_date_arr	    "contain card_date"
;line_cvv_arr       "contain card_cvv"
; Balance_amount    "contain card_cvv"
;*************************************************************************************
Cut_line proc

	call Get_line2

	mov edx, offset Pay 
	mov esi ,offset line_card_arr
	
mov ecx,pay_length
  line_card:								;this loop to lood card_num in arr
		mov al ,','
		cmp [edx],al
		je out_card
		mov al,[edx]
		mov [esi],al
		inc esi
		inc edx
		inc line_card_len
		jmp M

 out_card:
		   mov card_ecx ,ecx
		   mov ecx,1

  M:
 loop line_card
 sub card_ecx,1
 
 
inc edx
mov esi ,offset line_date_arr
mov ecx,card_ecx

line_date :								;this loop to lood date in line_date_arr
		mov al,','
		cmp [edx],al
		je out_date

		mov al,[edx]
		mov [esi],al
		inc esi
		inc edx
		inc line_date_len
		jmp D
out_date:
		mov date_ecx ,ecx
        mov  ecx,1
		D:
loop line_date 
 sub date_ecx,1

inc edx
mov esi ,offset line_cvv_arr
mov ecx,date_ecx
line_cvv :								;this loop to lood cvv in line_cvv_arr
			mov al,','
			cmp [edx],al
			je out_loop

			mov al,[edx]
			mov [esi],al
			inc esi
			inc edx
			inc line_cvv_len 
			jmp F
	out_loop:
		mov cvv_ecx,ecx
		mov ecx,1
	F:
 loop line_cvv

 sub cvv_ecx,1
 inc edx
mov esi ,offset line_name_arr
mov ecx,cvv_ecx
	line_name :								;this loop to lood cvv in line_cvv_arr
			mov al,','
			cmp [edx],al
			je out_name

			mov al,[edx]
			mov [esi],al
			inc esi
			inc edx
			inc line_name_len 
			jmp G
	out_name:
		mov name_ecx,ecx
		mov ecx,1
	G:
 loop line_name

inc edx
mov ecx, name_ecx
sub ecx,1
mov esi , offset  Balance_amount		;this to skip name because we know in right from frist
mov Balance_amount_len,0
Existing_Balance:					;this loop to lood cvv in line_cvv_arr
               
			   mov al , [edx]
			   mov [esi] , al
			   inc Balance_amount_len
		       inc edx
			   inc esi

loop Existing_Balance

ret
Cut_line endp
;*************************************Bouns***********************************************
;*************************procedure to add error in invalid_buffer:****************** 
Write_Invalid proc 

mov esi , offset invaled_buffer
add esi , inva_filename_length                    ; to mov esi at end of buffer and ready to concatinate 
mov edi , offset PAY_str_Card
mov ecx , PAY_str_Card_len
add invaled_buffer_length,ecx 
transfer_to_buffer:
                   mov  al , [edi]
				   mov [esi] , al
				   inc edi
				   inc esi
loop transfer_to_buffer

      call save_InvalidFile ;save in file 
     
done_invalid:

ret
Write_Invalid endp
;***************************** procedure to save invalid_buffer in invaled file:****************** 
save_InvalidFile proc 
		mov edx,OFFSET inva_filename
		call CreateOutputFile
		mov fileHandle,eax 

		; Check for errors.
		cmp eax, INVALID_HANDLE_VALUE ; error found?

		jne file_ok ; no: skip
			mov edx,OFFSET Message_Error ; display error
			call WriteString
		jmp quit

		file_ok:
				mov eax,fileHandle
				mov edx,OFFSET invaled_buffer
				mov ecx,invaled_buffer_length
				call WriteToFile

		call CloseFile
quit : 

ret 
save_InvalidFile endp

;**************************To  load form Invalid file in invaled_buffer : *******************
load_from_invalid_File proc 

		mov edx,OFFSET inva_filename
		call OpenInputFile
		mov fileHandle,eax
		cmp eax,INVALID_HANDLE_VALUE 
		jne file_ok 

		mov edx , offset Cant_open2 
		call writestring 

jmp quit

file_ok:

		mov edx,OFFSET invaled_buffer 
		mov ecx,lengthof invaled_buffer
		call ReadFromFile

		jnc check_buffer_size

		
			mov edx ,offset Error_read 
			call writestring 
			jmp close_file

		check_buffer_size:

			cmp eax,BUFFER_SIZE ; buffer large enough?
			jb buf_size_ok ; yes enough so jump now 

			mov edx , offset Buffer_small
			call writestring


		 jmp quit 

		buf_size_ok:

				add inva_filename_length, eax
				add invaled_buffer_length , eax 

			close_file :
					mov eax,fileHandle
					call CloseFile
			quit: 

ret

load_from_invalid_File endp 

END main

;##################################################################################
;################### Project E-Payment System ;####################
###################   Team Name WANGS
Team Leader : Wael mohamed 
Gehad Khaled 
Ahmed Mohsen 
Nehal Mohamed 
Sayed Ahmed 

TA Ressponsible Dr . Dina Hassan 

Dr Kaream Emara  And Dr Eslam 
