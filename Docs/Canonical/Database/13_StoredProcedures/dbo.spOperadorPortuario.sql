SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spOperadorPortuario]
as

SELECT 
	TP.ID_OP [ID], 
	TP.Descricao_OP [Descricao],
	TP.Ativo, 
	TP.Dt_Criacao [Criacao], 
	US.Nome_Usuario [Nome]

FROM 
	Tipo_Operador_Portuario TP 
JOIN Usuario US ON TP.Cd_Usuario = us.Cd_Usuario
GO
