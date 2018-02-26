TITLE MASM Template						(main.asm)
; Software criado por Hygor L.B.Marques, RA: 386073
; 
; Revision date:

INCLUDE Irvine32.inc
.data
newline BYTE 0dh,0ah,0
myMessage BYTE "--- MASMCELL: Um editor de planilhas no MASM. ---------",0dh,0ah, "                                     (por Hygor L.B. Marques)",0dh,0ah,0
MaxLinhas BYTE "----- Aviso! Nova linha nao adicionada pois maximo foi alcancado (8 linhas)!",0dh,0ah,"Pressione qualquer tecla pra continuar ---------",0
MaxColunas BYTE "----- Aviso! Nova coluna nao adicionada pois maximo alcancado (6 colunas)!",0dh,0ah,"Pressione qualquer tecla pra continuar ---------",0



menu BYTE "--> Pressione 1 pra comecar uma nova planilha.",0dh,0ah,
           "--> Pressione 2 pra carregar uma planilha.",0dh,0ah,
           "--> Pressione 3 para fechar!",0dh,0ah,0


menu0 BYTE "_____________________________________________________",0dh,0ah,
            "| Arquivo (1) | Operacoes (2)   | Editar tabela (3)",0dh,0ah,
            "----------------------------------------------------",0dh,0ah, 0

menu1 BYTE "_____________________________________________________",0dh,0ah,
            "| Arquivo     | Operacoes       | Editar tabela    |",0dh,0ah,
            " --------------------------------------------------|",0dh,0ah, 
            "|Salvar Tabela (1)  |",0dh,0ah,
            "|Carregar Tabela (2)|",0dh,0ah,
            "|Fechar Programa (3)|",0dh,0ah,0

menu2 BYTE "_____________________________________________________",0dh,0ah,
            "| Arquivo     | Operacoes       | Editar tabela    |",0dh,0ah,
            " --------------------------------------------------|",0dh,0ah, 
            "              |Adicionar Linha (1) |",0dh,0ah,
            "              |Adicionar Coluna (2)|",0dh,0ah,
            "              |                    |",0dh,0ah,0

menu3 BYTE "_____________________________________________________",0dh,0ah,
            "| Arquivo     | Operacoes       | Editar tabela    |",0dh,0ah,
            " --------------------------------------------------|",0dh,0ah, 
            "                                 |Editar campo (1) |",0dh,0ah,
            "                                 |Editar linha (2) |" ,0dh,0ah,
            "                                 |Editar coluna (3)|",0dh,0ah,0



NavMenu BYTE "Insira o numero da opcao correspondente no menu superior : ",0
Qual_linha BYTE "Coloque o numero da linha : ",0
Qual_coluna BYTE "Coloque o numero da coluna : ",0
Qual_valor  BYTE "Qual valor voce quer associar a esse campo",0dh,0ah,
                 "(em caso de editar linha ou coluna, os valores irao na ordem) : ",0


 Risco BYTE "___________________________________________________________________________",0dh, 0ah,0
 CabColunas BYTE "|__________|",0,"____A_____|",0,"____B_____|",0,"____C_____|",0,"____D_____|",0,"____E_____|",0,"____F_____|",0,"____G_____|",0,"____H_____|",0dh,0ah,0
 CabLinhas BYTE  "|____1_____|",0,"|____2_____|",0,"|____3_____|",0,"|____4_____|",0,"|____5_____|",0,"|____6_____|",0,"|____7_____|",0,"|____8_____|",0
 Vazio  BYTE "__________|",0

testando DWORD "12"


nLinhas DWORD ?
nColunas DWORD ?
bLinhas BYTE ?
bColunas BYTE ?
Lin1 BYTE 6 DUP ("________")
Lin2 BYTE 6 DUP ("________")
Lin3 BYTE 6 DUP ("________")
Lin4 BYTE 6 DUP ("________")
Lin5 BYTE 6 DUP ("________")
Lin6 BYTE 6 DUP ("________")
Lin7 BYTE 6 DUP ("________")
Lin8 BYTE 6 DUP ("________")
Tam1 BYTE 6 DUP (0)
Tam2 BYTE 6 DUP (0)
Tam3 BYTE 6 DUP (0)
Tam4 BYTE 6 DUP (0)
Tam5 BYTE 6 DUP (0)
Tam6 BYTE 6 DUP (0)
Tam7 BYTE 6 DUP (0)
Tam8 BYTE 6 DUP (0)


tamanho DWORD ?
linha_selecionada DWORD 0
coluna_selecionada DWORD 0
menu_selecionado DWORD 0
opcao_selecionada DWORD 0

valor BYTE "________"
barra BYTE "|",0
underline BYTE "_",0
menu_atual DWORD ?
EndrArquivo BYTE "tabela_teste.txt",0
arquivo BYTE 10000 DUP(?),0



.code
main PROC



;---------------------Menu Inicial --------------------
    call MenuInicial
    
;----------------- Menu superior (principal) -----------------
    MenuSuperior::
    call Clrscr
    cmp al,0
    je PrintMenu0
    cmp al,1
    je PrintMenu1
    cmp al,2
    je PrintMenu2
    cmp al,3
    je PrintMenu3

;-------------- Cada um dos menus ------------------------------
    PrintMenu0:
    call PMenu0
    mov ebx,0
    mov menu_atual, ebx
    jmp PrintTable


    PrintMenu1:
    call PMenu1
    mov ebx,1
    mov menu_atual, ebx
    jmp PrintTable

    PrintMenu2:
    call PMenu2
    mov ebx, 2
    mov menu_atual, 2
    jmp PrintTable

    PrintMenu3:
    call PMenu3
    mov ebx, 3
    mov menu_atual, ebx
    jmp PrintTable


;----------------- Procedimento de printar a tabela --------------------------

PrintTable::
    mov esi, OFFSET Tam1
    call PPrintTable

;---------------Procedimento de mostrar opcoes do MAMSCELL ------------------
_Opcoes::
   call PegaOpcao

;------------ Caso uma opcao foi pega dentro do menu operacoes verifica qual operacao vamos realizar

;----- (1) Arquivo
OpArquivo::
    mov edx, OFFSET newline
    call WriteString
    push eax
    cmp eax,1
    je Salva_Planilha
    cmp eax,2
    je Carrega_Planilha
    cmp eax,3
    je About_MASMCELL


    Salva_Planilha::
    call EscreverArquivo

    Carrega_Planilha::
    call LerArquivo


;----- (2) Operacoes
Operacoes::
    mov edx, OFFSET newline
    call WriteString
    push eax
    cmp eax, 1
    je Nova_Linha
    cmp eax, 2
    je Nova_Coluna

     Nova_Linha::
     call InsereLinha


    Nova_Coluna::
    call InsereColuna


;------ (3) Editar Tabela
Editar_Tabela::
    mov edx, OFFSET newline
    call WriteString
    mov opcao_selecionada, eax
    cmp eax, 1
    je Editar_Campo
    cmp eax, 2
    je Editar_Linha
    cmp eax, 3
    je Editar_Coluna
    mov ebx, 0
    mov menu_atual, ebx
    mov eax, 0
    jmp MenuSuperior


;-------Pra editar um campo inicialmente se pergunta a linha e a coluna a ser editada e entao chama o procedimento EditaCampo
    Editar_Campo:
    mov edx, OFFSET Qual_linha
    call WriteString
    call ReadDec
    mov linha_selecionada, eax 
    mov edx, OFFSET newline
    call WriteString
    mov edx, OFFSET Qual_coluna
    call WriteString
    call ReadDec
    mov coluna_selecionada , eax 

Editar_Um_Campo::
     call EditaCampo

;-------Pra editar uma linha se pergunta qual e a linha e depois enquanto nao preencher todas colunas, chama EditaCampo pro valor pego
Editar_Linha:
     mov edx, OFFSET Qual_linha
    call WriteString
    call ReadDec
    mov linha_selecionada, eax 
    mov edx, OFFSET newline
    call WriteString

    Proximo_Campo_da_Linha:
    inc coluna_selecionada
    mov ebx, coluna_selecionada
    cmp ebx, nColunas
    jna Editar_um_Campo 
    jmp FimDasOperacoes

;-------Pra editar uma coluna se pergunta qual e a coluna e depois enquanto nao preencher todas linhas, chama EditaCampo pro valor pego
Editar_Coluna:
     mov edx, OFFSET Qual_coluna
    call WriteString
    call ReadDec
    mov coluna_selecionada, eax 
    mov edx, OFFSET newline
    call WriteString

    Proximo_Campo_da_Coluna:
    inc linha_selecionada
    mov ebx, linha_selecionada
    cmp ebx, nLinhas
    jna Editar_um_Campo 
    jmp FimDasOperacoes

;----Codigo chega aqui apos a edicao de um campo da planilha. 
;--------> Verifica-se se a opcao pega foi editar linha, nesse caso sai para editar o "Proximo campo da linha".
;--------> Verifica-se se a opcao pega foi editar coluna, nesse caso sai para editar o "Proximo campo da coluna".
fim_edicao::
   mov eax, opcao_selecionada
   cmp eax,2 ; Editar linha
   jne nao_linha 
   push eax
   jmp Proximo_Campo_da_Linha 

   nao_linha:  
   cmp eax,3 ; Editar coluna
   jne FimDasOperacoes; Opcao foi editar campo, ja foi feito
   push eax
   jmp Proximo_Campo_da_Coluna

   FimDasOperacoes::
   mov linha_selecionada, 0
   mov coluna_selecionada, 0
   mov menu_atual, 0
   mov al,0 
   jmp MenuSuperior

    About_MASMCELL::

    exit
    main ENDP

MenuInicial PROC
    mov edx,OFFSET MyMessage
    call WriteString
    mov edx, OFFSET newline
    call WriteString
    mov edx, OFFSET menu
    call WriteString

    call ReadDec
    cmp eax,1
    jne TentaLer
    mov eax, 5
    mov nLinhas, eax
    mov eax, 4
    mov nColunas, eax
    mov eax,0
    jmp NaoTentaLer

    TentaLer:
    call LerArquivo
    jmp PrintTable

    NaoTentaLer:

    ret
    MenuInicial ENDP

PMenu0 PROC
    mov	 edx,OFFSET menu0
    call WriteString
    mov eax, 0
    mov ecx, 4
    mov edx, OFFSET newline
    p4linha:
    call WriteString
    loop p4linha
    mov eax,0
    ret 
PMenu0 ENDP

PMenu1 PROC
    mov	 edx,OFFSET menu1
    call WriteString
    mov eax, 0
    mov ecx, 4
    mov edx, OFFSET newline
    p4linha:
    call WriteString
    loop p4linha
    retn 0
PMenu1 ENDP

PMenu2 PROC
    mov edx, OFFSET menu2
    call WriteString
    mov edx, OFFSET newline
    call WriteString
    ret
PMenu2 ENDP

PMenu3 PROC
    mov	 edx,OFFSET menu3
    call WriteString
    mov edx,OFFSET newline
    call WriteString
    ret
PMenu3 ENDP

;-------- Maior funcao (conversar com professor)
PPrintTable PROC
    ;-----------Risco inicial 
        mov edx, OFFSET Risco
        call WriteString

    ;-----Desenhando o cabeçalho de colunas
        mov ecx,nColunas
        mov edx, OFFSET CabColunas
        call WriteString
        inc edx
        L1:
        add edx, 12
        call WriteString
        loop L1

    mov edx, OFFSET newline
    call WriteString

   ;----------- Desenhando as linhas 
        mov ecx,nLinhas 
        mov edx, OFFSET CabLinhas

        ;--------------- Desenhando cada linha
         L2:
            add linha_selecionada, 1
            mov coluna_selecionada, 0
            call WriteString
            push ecx
            push edx
            mov ecx,nColunas
            mov ebx, 0

           ;-----Desenhando cada bloco
           L3:
                add coluna_selecionada, 1
                push ecx ;------ nColunas, CabLinhas(restantes), nLinhas na pilha(restantes)
                mov eax, linha_selecionada

                ;mov edx, 1
                ;LBom:
                ;mov ecx, [esi + ebx]
                ;cmp eax,edx
                ;je e_esse
                ;inc edx
                ;add esi, 24
                ;jmp LBom

                cmp eax, 1
                jne tenta_2
                movsx ecx, [Tam1 + ebx]
                jmp e_esse
                tenta_2:
                cmp eax, 2
                jne tenta_3
                movsx ecx, [Tam2+ ebx]
                jmp e_esse
                tenta_3:
                cmp eax, 3
                jne tenta_4 
                movsx ecx, [Tam3+ ebx]
                jmp e_esse
                tenta_4:
                cmp eax, 4
                jne tenta_5 
                movsx ecx, [Tam4+ ebx]
                jmp e_esse
                tenta_5:
                cmp eax, 5
                jne tenta_6 
                movsx ecx, [Tam5+ ebx]
                jmp e_esse
                tenta_6:
                cmp eax, 6
                jne tenta_7 
                movsx ecx, [Tam6+ ebx]
                jmp e_esse
                tenta_7:
                cmp eax, 7
                jne tenta_8 
                movsx ecx, [Tam7+ ebx]
                jmp e_esse
                tenta_8:
                movsx ecx, [Tam8 +ebx]

                e_esse:

            ;-Antes da variavel
                mov edx, OFFSET underline
                call WriteString
                cmp ecx, 7
                jae p_variavel
                call WriteString
                cmp ecx, 5
                jae p_variavel
                call WriteString
                cmp ecx, 3
                jae p_variavel
                call WriteString
                cmp ecx,0
                ja p_variavel
                call WriteString
                push ebx ; EBX(0), nColunhas, CabLinhas(restantes), nLinhas na pilha(restantes)
                mov ebx,0
                jmp outro_lado

            ;-A variavel desejada no bloco
                p_variavel:
                push ebx ; EBX(0), nColunhas, CabLinhas(restantes), nLinhas na pilha(restantes)
                mov ebx,0

                variavel:
                  push ecx ; ECX(0), EBX(0), nColunhas, CabLinhas(restantes), nLinhas na pilha(restantes)
                  mov ecx, linha_selecionada
                  mov edx, coluna_selecionada
                  dec edx
                  cmp ecx, 1
                  jne vai_2
                  mov al, [Lin1 + ebx + (8*edx)]
                  jmp vai_fora
                  vai_2:
                  cmp ecx, 2
                  jne vai_3
                  mov al, [Lin2 + ebx + (8*edx)]
                  jmp vai_fora
                  vai_3:
                  cmp ecx, 3
                  jne vai_4
                  mov al, [Lin3 + ebx  + (8*edx)]
                  jmp vai_fora
                  vai_4:
                  cmp ecx, 4
                  jne vai_5
                  mov al, [Lin4 + ebx  + (8*edx)]
                  jmp vai_fora
                  vai_5:
                  cmp ecx, 5
                  jne vai_6
                  mov al, [Lin5 + ebx  + (8*edx)]
                  jmp vai_fora
                  vai_6:
                  cmp ecx, 6
                  jne vai_7
                  mov al, [Lin6 + ebx  + (8*edx)]
                  jmp vai_fora
                  vai_7:
                  cmp ecx, 7
                  jne vai_8
                  mov al, [Lin7 + ebx  + (8*edx)]
                  jmp vai_fora
                  vai_8:
                  mov al, [Lin8 + ebx + (8*edx)]

                  vai_fora:
                  call WriteChar
                  inc ebx
                  pop ecx ; <-ECX(0), | EBX(0), nColunhas, CabLinhas(restantes), nLinhas na pilha(restantes)
                  loop variavel

            ;-Apos a variavel
                outro_lado:
                  pop ebx
                  mov edx, linha_selecionada
                  cmp edx, 1
                  jne vaii_2
                  movsx ecx, [Tam1 + ebx]
                  jmp vaii_fora
                  vaii_2:
                  cmp edx, 2
                  jne vaii_3
                  movsx ecx, [Tam2 + ebx]
                  jmp vaii_fora
                  vaii_3:
                  cmp edx, 3
                  jne vaii_4
                  movsx ecx, [Tam3 + ebx]
                  jmp vaii_fora
                  vaii_4:
                  cmp edx, 4
                  jne vaii_5
                  movsx ecx, [Tam4 + ebx]
                  jmp vaii_fora
                  vaii_5:
                  cmp edx, 5
                  jne vaii_6
                  movsx ecx, [Tam5 + ebx]
                  jmp vaii_fora
                  vaii_6:
                  cmp edx, 6
                  jne vaii_7
                  movsx ecx, [Tam6 + ebx]
                  jmp vaii_fora
                  vaii_7:
                  cmp edx, 7
                  jne vaii_8
                  movsx ecx, [Tam7 + ebx]
                  jmp vaii_fora
                  vaii_8:
                  movsx ecx, [Tam8 + ebx]

                  vaii_fora:
                  mov edx, OFFSET underline
                  call WriteString
                  cmp ecx, 7
                  ja barra_final
                  call WriteString
                  cmp ecx, 5
                  ja barra_final
                  call WriteString
                  cmp ecx, 3
                  ja barra_final
                  call WriteString
                  cmp ecx,0
                  ja barra_final
                  call WriteString

            ;- Barra final e preparacao para o proximo bloco:
                barra_final:
                  mov edx, OFFSET barra
                  call WriteString
                  add ebx,1
                  pop ecx
                  dec ecx
                  cmp ecx,0
                  jne L3

            ;--- Terminou de imprimir a linha, passa para a proxima:
                mov edx, OFFSET newline
                call WriteString
                pop edx
                pop ecx
                dec ecx
                add edx, 13
                cmp ecx, 0
                jne L2

    ret
PPrintTable ENDP


PegaOpcao PROC
   mov edx, OFFSET newline
   mov ecx, 4
   pula_4Linhas:
   call WriteString
   loop pula_4Linhas

   mov edx, OFFSET NavMenu
   call WriteString
   mov eax, 0
   call ReadDec
   mov linha_selecionada, 0
   mov coluna_selecionada, 0

   cmp menu_atual, 0
   je MenuSuperior

 ;------ O menu (1) eh relevante as operacoes de arquivo (salvar/carregar)
cmp menu_atual, 1
je OpArquivo


  ;------ O menu (2) eh relevante as operacoes da planilha
  cmp menu_atual, 2
   je Operacoes

  ;------ O menu (3) eh relevante as possibilidades de editar a planilha
   cmp menu_atual,3
   je  Editar_Tabela

   ret
PegaOpcao ENDP

InsereLinha PROC
    inc nLinhas
    cmp nLinhas, 8
    ;---Caso nao exceder o limite, printa a planilha com nova linha.
    jna FimDasOperacoes
    ;---Se exceder o limite e preciso avisar o usuario.
    mov edx,OFFSET MaxLinhas
    call WriteString
    dec nLinhas
    call ReadChar
    jmp FimDasOperacoes

    ret
InsereLinha ENDP

InsereColuna PROC
    inc nColunas
    cmp nColunas, 6
    ;---Caso nao exceder o limite, printa a planilha com nova coluna.
    jna FimDasOperacoes
    ;---Se exceder o limite e preciso avisar o usuario.
    mov edx,OFFSET MaxColunas
    call WriteString
    dec nColunas
    call ReadChar
    jmp FimDasOperacoes

    ret
InsereColuna ENDP

EditaCampo PROC
    mov edx, OFFSET newline
    call WriteString
    mov edx, OFFSET Qual_valor
    call WriteString
    mov edx, OFFSET valor
    mov ecx, 8
    call ReadString
    ;;---- eax fica com o tamanho da string lida pelo ReadString
    mov tamanho, eax
    mov ebx, 0
    mov ecx, coluna_selecionada
    dec ecx
    cmp linha_selecionada, 1
    jne alinha_2

    mov [Tam1 +(ecx)], al
    alinha_1:
    mov al, [edx + ebx]
    mov [Lin1 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp alinha_1

    alinha_2:
    cmp linha_selecionada, 2
    jne alinha_3
    mov [Tam2 +(ecx)], al
    _alinha_2:
    mov al, [edx + ebx]
    mov [Lin2 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_2

    alinha_3:
    cmp linha_selecionada, 3
    jne alinha_4
    mov [Tam3 +(ecx)], al
    _alinha_3:
    mov al, [edx + ebx]
    mov [Lin3 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_3

    alinha_4:
    cmp linha_selecionada, 4
    jne alinha_5
    mov [Tam4 +(ecx)], al
    _alinha_4:
    mov al, [edx + ebx]
    mov [Lin4 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_4

    alinha_5:
    cmp linha_selecionada, 5
    jne alinha_6
    mov [Tam5 +(ecx)], al
    _alinha_5:
    mov al, [edx + ebx]
    mov [Lin5 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_5

    alinha_6:
    cmp linha_selecionada, 6
    jne alinha_7
    mov [Tam6 +(ecx)], al
    _alinha_6:
    mov al, [edx + ebx]
    mov [Lin6 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_6

    alinha_7:
    cmp linha_selecionada, 7
    jne alinha_8
    mov [Tam7 +(ecx)], al
    _alinha_7:
    mov al, [edx + ebx]
    mov [Lin7 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_7

    alinha_8:
    mov [Tam8 +(ecx)], al
    _alinha_8:
    mov al, [edx + ebx]
    mov [Lin8 + ebx + (ecx*8)], al 
    inc ebx
    cmp ebx, tamanho
    je fim_edicao
    jmp _alinha_8
    mov edx, OFFSET newline
    call WriteString
    ret
EditaCampo ENDP


;---------------
LerArquivo PROC
mov edx, OFFSET EndrArquivo
call OpenInputFile
mov edx, OFFSET bLinhas
mov ecx,1000
call ReadFromFile
mov eax,0

mov al, [bLinhas]
add eax, -48
mov nLinhas, eax
mov al, [bColunas]
add eax, -48
mov nColunas, eax

mov ecx,0
mov esi, OFFSET Tam1

ASCTOINC:
mov eax,0
mov ebx,0
mov bl,[esi+ecx]
add bl, -48
mov al,bl
call WriteDec
mov [esi+ecx], bl
inc ecx
cmp ecx,48
jne ASCTOINC


jmp FimDasOperacoes
    ret
LerArquivo ENDP



EscreverArquivo PROC
mov eax, nLinhas
mov ebx, nColunas
mov esi, OFFSET arquivo
;------Deixando o nLinhas e o nColunas
add al,48
mov [esi], al
inc esi
add bl,48
mov [esi], bl
inc esi
mov edx, OFFSET Lin1
mov ecx,0

;----Pra copiar o vetor
CopiaVetor:
mov ebx, [edx + ecx]
cmp ecx, 384
jb NAOASCII
add bl,48
NAOASCII:
mov [esi+ecx], ebx
inc ecx
cmp ecx, 432
jne CopiaVetor

call CloseFile
mov edx, OFFSET EndrArquivo
call CreateOutputFile
mov edx, OFFSET arquivo
mov ecx, 434
call WriteToFile
call WriteDec


jmp FimDasOperacoes


ret
EscreverArquivo ENDP


END main



