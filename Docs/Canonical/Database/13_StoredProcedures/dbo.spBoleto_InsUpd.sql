SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --(select left(right(Replace(convert(nchar(10),getdate(),102),'.',''),6),4))  

CREATE procedure [dbo].[spBoleto_InsUpd]  
  
 @cd_boleto  varchar(8),  
 @agencia  varchar(4),  
 @conta   varchar(12),  
-- @cd_sacado  varchar(10),  
 @fatura   varchar(17),  
 @cd_usuario  varchar(6),  
 @valor   decimal(12,2),  
 @cd_instrucao01 varchar(2),  
 @cd_instrucao02 varchar(2),  
 @cd_banco varchar(3), -- Alessandra 22/03/2022 - preciso saber qual o banco para selecionar as instruções corretas
 @cd_boletot varchar(8) OUTPUT  
  
  
AS  
  
 Begin Transaction   
  
 Declare @Lote varchar(15)  
 Declare @int as int   
 Declare @cd_sacado as varchar(10)  
  
 if len(@fatura)= 8  
  begin  
   set @cd_sacado = (select cd_pes from NF_Fatura where Numero_Fat = @fatura)   
  end  
 else  
  begin  
   set @cd_sacado = (select cd_pes from fatura where fatcod = @fatura)   
  end    
  
 --Declare @Lote varchar(15)  
 --Declare @int as int   
 Set @Int=(Select isnull(max(right(cd_boleto,4))+1,1) from Boleto   
  where left(right(Replace(convert(nchar(10),dt_boleto,102),'.',''),6),4)  
  = left(right(Replace(convert(nchar(10),getdate(),102),'.',''),6),4))   
  --print  @int  
 --Set @Lote = (select right(Replace(convert(nchar(10),getdate(),102),'.',''),4))  
 Set @Lote =(select left(right(Replace(convert(nchar(10),getdate(),102),'.',''),6),4))  
 Set @Lote= @Lote + right('0000'+Cast(@int as VarChar),4)  
  
  
  IF @cd_instrucao01 = '39' -- GAMBIARRA DE EXCEÇÃO POIS IMPACTA O FATURAMENTO, SIBÉRIO IRÁ ABRIR UM MINOR PARA TRATAR EM DEFINITIVO
	SET @cd_instrucao01 = ''
  
  
 if @cd_boleto is null  
  
  BEGIN  
   INSERT  
    Boleto(  
     cd_boleto,dv,Inscricao_Numero,Agencia_Cedente,Conta_Cedente,cd_pes,FatCod,dt_Boleto,  
     cd_usuario,valor,dt_emissao_txt,cd_instrucao_01,cd_instrucao_02, cd_banco --Alessandra 22/03/2022 - Adicionado cd_banco
     )  
   Values  
    (  
     @Lote,null,'03706460000128',@agencia,@conta,@cd_sacado,@fatura,getdate(),  
     @cd_usuario,@valor,null,@cd_instrucao01,@cd_instrucao02 ,@cd_banco  --Alessandra 22/03/2022 - Adicionado cd_banco    
    )   
  
   set @cd_boletot = @Lote    
  END     
 else if exists(select * from boleto where cd_boleto = @cd_boleto and dt_emissao_txt is null)  
  Begin  
   Update  
    Boleto  
   set    
    cd_pes = @cd_sacado,  
    dt_Boleto = getdate(),  
    cd_usuario = @cd_usuario,  
    valor = @valor,  
    cd_instrucao_01 = @cd_instrucao01,  
    cd_instrucao_02 = @cd_instrucao02,
	cd_banco = @cd_banco--Alessandra 22/03/2022 - Adicionado cd_banco
   where   
    cd_boleto = @cd_boleto   
    and dt_emissao_txt is null  
     
   set @cd_boletot = @cd_boleto  
  End  
  
 IF @@Error <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   RETURN -1  
  END  
Commit Transaction  
  
  
  
  
  
  
  
  
  

 
 
 /* 
ALTER procedure [dbo].[spBoleto_InsUpd]  
  
 @cd_boleto  varchar(8),  
 @agencia  varchar(4),  
 @conta   varchar(12),  
-- @cd_sacado  varchar(10),  
 @fatura   varchar(17),  
 @cd_usuario  varchar(6),  
 @valor   decimal(12,2),  
 @cd_instrucao01 varchar(2),  
 @cd_instrucao02 varchar(2),  
 @cd_boletot varchar(8) OUTPUT  
  
  
AS  
  
 Begin Transaction   
  
 Declare @Lote varchar(15)  
 Declare @int as int   
 Declare @cd_sacado as varchar(10)  
  
 if len(@fatura)= 8  
  begin  
   set @cd_sacado = (select cd_pes from NF_Fatura where Numero_Fat = @fatura)   
  end  
 else  
  begin  
   set @cd_sacado = (select cd_pes from fatura where fatcod = @fatura)   
  end    
  
 --Declare @Lote varchar(15)  
 --Declare @int as int   
 Set @Int=(Select isnull(max(right(cd_boleto,4))+1,1) from Boleto   
  where left(right(Replace(convert(nchar(10),dt_boleto,102),'.',''),6),4)  
  = left(right(Replace(convert(nchar(10),getdate(),102),'.',''),6),4))   
  --print  @int  
 --Set @Lote = (select right(Replace(convert(nchar(10),getdate(),102),'.',''),4))  
 Set @Lote =(select left(right(Replace(convert(nchar(10),getdate(),102),'.',''),6),4))  
 Set @Lote= @Lote + right('0000'+Cast(@int as VarChar),4)  
  
  
  IF @cd_instrucao01 = '39' -- GAMBIARRA DE EXCEÇÃO POIS IMPACTA O FATURAMENTO, SIBÉRIO IRÁ ABRIR UM MINOR PARA TRATAR EM DEFINITIVO
	SET @cd_instrucao01 = ''
  
  
 if @cd_boleto is null  
  
  BEGIN  
   INSERT  
    Boleto(  
     cd_boleto,dv,Inscricao_Numero,Agencia_Cedente,Conta_Cedente,cd_pes,FatCod,dt_Boleto,  
     cd_usuario,valor,dt_emissao_txt,cd_instrucao_01,cd_instrucao_02  
     )  
   Values  
    (  
     @Lote,null,'03706460000128',@agencia,@conta,@cd_sacado,@fatura,getdate(),  
     @cd_usuario,@valor,null,@cd_instrucao01,@cd_instrucao02      
    )   
  
   set @cd_boletot = @Lote    
  END     
 else if exists(select * from boleto where cd_boleto = @cd_boleto and dt_emissao_txt is null)  
  Begin  
   Update  
    Boleto  
   set    
    cd_pes = @cd_sacado,  
    dt_Boleto = getdate(),  
    cd_usuario = @cd_usuario,  
    valor = @valor,  
    cd_instrucao_01 = @cd_instrucao01,  
    cd_instrucao_02 = @cd_instrucao02  
   where   
    cd_boleto = @cd_boleto   
    and dt_emissao_txt is null  
     
   set @cd_boletot = @cd_boleto  
  End  
  
 IF @@Error <> 0  
  BEGIN  
   ROLLBACK TRANSACTION  
   RETURN -1  
  END  
Commit Transaction  
  
   
  

  */
GO
