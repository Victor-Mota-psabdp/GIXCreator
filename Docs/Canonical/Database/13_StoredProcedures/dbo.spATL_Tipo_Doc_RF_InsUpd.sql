SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Doc_RF
CREATE PROCEDURE [dbo].[spATL_Tipo_Doc_RF_InsUpd]
(
	@Cd_Tipo_Doc_RF		varchar(1),
	@Descricao_Tp_Doc	varchar(50),
	@Ativo				varchar(1),
	@Debito				varchar(2),
	@Credito			varchar(2)
)	

AS

Begin Transaction

	If  exists (select Cd_Tipo_Doc_RF from Tipo_Doc_RF where Cd_Tipo_Doc_RF=@Cd_Tipo_Doc_RF)
	Begin
		Update
			Tipo_Doc_RF
		Set
			Descricao_Tp_Doc=@Descricao_Tp_Doc,
			Debito=@Debito,
			Credito=@Credito,
			Ativo = @Ativo
		Where
			Cd_Tipo_Doc_RF=@Cd_Tipo_Doc_RF
	End
	Else
		Insert Tipo_Doc_RF
			(Cd_Tipo_Doc_RF,Descricao_Tp_Doc,Ativo,Debito,Credito)
		Values
			(@Cd_Tipo_Doc_RF,@Descricao_Tp_Doc,@Ativo,@Debito,@Credito)
	

Commit Transaction

GO
