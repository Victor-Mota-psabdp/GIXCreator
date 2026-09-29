SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spBusca_Tipo_Alerta_Redestinacao_Sel] 
	@Nome_TP_Alerta varchar(200)
as

select id_tp_alerta, regra,Stored from Tipo_Alerta_Redestinacao
where Nome_TP_Alerta = @Nome_TP_Alerta
GO
