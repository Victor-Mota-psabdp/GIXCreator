SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spTipo_RetificacaoDI_Sel 0

CREATE PROCEDURE [dbo].[spTipo_RetificacaoDI_sel]--0
	@ID_TP_RET bigint
	
as

SELECT 
	TP.ID_TP_RET [ID], 
	TP.NOME_TP_RET [Descricao], 
	US.Nome_Usuario [Usuario], 
	TP.Ativo
FROM 
	Tipo_RetificacaoDI TP 
JOIN Usuario US ON TP.Cd_Usuario = us.Cd_Usuario
where
	(@ID_TP_RET = 0 and TP.ID_TP_RET like '%')
	or
	(TP.ID_TP_RET  = @ID_TP_RET )
	
GO
