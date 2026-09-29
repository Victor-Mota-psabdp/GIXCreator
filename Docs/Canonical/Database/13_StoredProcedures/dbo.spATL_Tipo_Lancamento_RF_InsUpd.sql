SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Lancamento_RF
CREATE PROCEDURE [dbo].[spATL_Tipo_Lancamento_RF_InsUpd]
(
	@Cd_Tipo_Lanc				varchar(1),
	@Descricao_Tp_Lancamento	varchar(30),
	@Ativo varchar(1)
)	

AS

Begin Transaction

	If  exists (select Cd_Tipo_Lanc from Tipo_Lancamento_RF where Cd_Tipo_Lanc=@Cd_Tipo_Lanc)
	Begin
		Update
			Tipo_Lancamento_RF
		Set
			Descricao_Tp_Lancamento=@Descricao_Tp_Lancamento,
			Ativo = @Ativo
		Where
			Cd_Tipo_Lanc=@Cd_Tipo_Lanc
	End
	Else
		Insert Tipo_Lancamento_RF
			(Cd_Tipo_Lanc,Descricao_Tp_Lancamento,Ativo)
		Values
			(@Cd_Tipo_Lanc,@Descricao_Tp_Lancamento,@Ativo)
	

Commit Transaction

GO
