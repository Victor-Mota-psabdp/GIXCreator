SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Modal_Imp_Exp
CREATE procedure [dbo].[spATL_Tipo_Modal_Imp_Exp_Del]
(
	@CD_TP_MODAL varchar(2)
)
as
	UPDATE Tipo_Modal_Imp_Exp SET Status= 0 where CD_TP_MODAL= @CD_TP_MODAL

GO
