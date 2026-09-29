SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spEndereco_InsUpd] --'P14033','Comercial','TESTE1','ANDAR','07700-000','TESTE', 'TESTE CITY','SP','Brazil'

			@cd_pes 	varchar(10),
			@Tipo_Endereco 	varchar(20)='COM',
			@Rua		varchar(40),
			@Numero		varchar(10),
			@Compl_End	varchar(25),
			@CEP		varchar(8),
			@Bairro		varchar(100),
			@Cidade		varchar(25),
			@UF			varchar(2),
			@Pais		varchar(50)

AS


Begin Transaction
	Declare @Cod Varchar(10)
	Declare @Cd_pais Varchar(2)
	Declare @SCAC Varchar(3)

	Set @Cd_Pais=(select cd_pais from pais where nome_pais=@Pais)
	set @SCAC = (select top 1 un_loctn_cd from bdpint_localidade where iso_2_ltr_cntry_cd=@cd_pais and un_loctn_nm=@cidade)
	



	Set @Cod=(select cd_tp_end from tipo_endereco where nome_tp_end=@Tipo_Endereco)

	If  exists (select cd_tp_end from endereco where cd_pes=@cd_pes and cd_tp_end=@Cod)
	   Begin
		Update
			Endereco
		Set
			
			Numero = @Numero,
			Rua=@RUA,			
			Compl_End=@Compl_End,
			CEP=@CEP,
			Bairro=@Bairro,
			Cidade=@Cidade,
			UF=@UF,
			Pais=LEFT(@Pais,50), 
			Cd_Pais=@cd_Pais,
			SCAC=@SCAC
		Where
			cd_pes=@cd_pes and cd_tp_end=@Cod
	   End
	Else
	   Begin
		Insert
			Endereco
			(
			Cd_pais,
			SCAC,
			Numero,
			cd_pes,
			cd_tp_end,
			Rua,
			Compl_End,
			CEP,
			Bairro,
			UF,
			Cidade,
			Pais
			)
		Values
			(
			@Cd_PAis,
			@SCAC,
			@Numero,
			@cd_pes,
			@Cod,
			@Rua,
			@Compl_End,
			@CEP,
			@Bairro,
			@UF,
			@cidade,
			LEFT(@Pais,50)
			)
	End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION






GO
