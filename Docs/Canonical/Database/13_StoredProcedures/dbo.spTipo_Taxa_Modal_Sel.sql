SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTipo_Taxa_Modal_Sel]--'BRO' 
	@cd_tp_tx varchar(3)
as	

SELECT 
	T.Cd_Tp_Tx Codigo, M.Nome_TP_MODAL, O.Nome_Tp_Oper
FROM
	Tipo_Taxa_Modal T 
	join Tipo_Modal_Imp_Exp M on M.CD_TP_MODAL = T.Cd_Tp_Modal	
	join Tipo_Oper O on O.Cd_Tp_Oper = T.Cd_Tp_Oper	
WHERE 
	T.Cd_Tp_Tx = @cd_tp_tx
GO
