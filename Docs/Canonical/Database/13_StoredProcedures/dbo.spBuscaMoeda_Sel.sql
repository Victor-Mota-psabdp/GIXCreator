SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[spBuscaMoeda_Sel]
@Cd_Tp_Moeda varchar(3),
@Nome_Tp_Moeda varchar(30)
		
AS

IF @Nome_Tp_Moeda is not NULL or @Nome_Tp_Moeda <> ''
	Begin
		SELECT cd_tp_moeda FROM Tipo_Moeda With(nolock) where Nome_Tp_Moeda = @Nome_Tp_Moeda and Ativo = 1
	End
Else
	Begin
		SELECT Nome_Tp_Moeda FROM Tipo_Moeda With(nolock) where cd_tp_moeda = @Cd_Tp_Moeda and Ativo = 1
	End






GO
