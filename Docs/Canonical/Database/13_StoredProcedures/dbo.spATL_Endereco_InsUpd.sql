SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Endereco
CREATE PROCEDURE [dbo].[spATL_Endereco_InsUpd] 
(  
	@cd_pes			varchar(10),  
	@Cd_Tp_End		varchar(3), 
	@Rua			Varchar(40),  
	@Numero			varchar(10),  
	@Compl_End		varchar(25),  
	@CEP			varchar(8),  
	@Bairro			varchar(100),  
	@Cidade			varchar(25),  
	@UF				varchar(2),  
	@Pais			varchar(50),--cadu 07112024
	@Cd_Pais		varchar(2),
	--@SCAC			varchar(3),
	@Cod_IBGE 		varchar(5)
) 
  
AS  
  
  
Begin Transaction  
	Declare @SCAC Varchar(3)
	set @SCAC = (select top 1 un_loctn_cd from bdpint_localidade 
				where iso_2_ltr_cntry_cd=@cd_pais and un_loctn_nm=@cidade)    
  
If  exists (select cd_tp_end from endereco where cd_pes=@cd_pes and cd_tp_end=@Cd_Tp_End)  
	Begin  
		Update
			Endereco  
		Set 
			Rua=@RUA,    
			Numero = @Numero,
			Compl_End=@Compl_End,  
			CEP=@CEP,  
			Bairro=@Bairro,  
			Cidade=@Cidade,  
			UF=@UF,  
			Pais=LEFT(@Pais,15),  
			Cd_Pais=@cd_Pais,  
			SCAC=@SCAC,
			Cod_IBGE=@Cod_IBGE
		Where  
			cd_pes=@cd_pes and cd_tp_end=@Cd_Tp_End  
	End  
 Else  
    Begin  
		Insert into Endereco
			(cd_pes,cd_tp_end,Rua,Numero,Compl_End,CEP,Bairro,Cidade,UF,Pais,Cd_pais,SCAC,Cod_IBGE)  
		Values  
			(@cd_pes,@Cd_Tp_End,@Rua,@Numero,@Compl_End,@CEP,@Bairro,@cidade,@UF,LEFT(@Pais,15),@Cd_PAis,@SCAC,@Cod_IBGE)  
 End  
  
IF @@Error <> 0  
 BEGIN  
  ROLLBACK TRANSACTION  
  RETURN -1  
 END  
  
  
COMMIT TRANSACTION  
  
  
  
  
  
GO
