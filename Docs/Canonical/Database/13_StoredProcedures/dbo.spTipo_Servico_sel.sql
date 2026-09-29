SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTipo_Servico_sel]--0
	@Id_TP_Servico bigint
	
as

SELECT 
	TP.Id_TP_Servico [ID], 
	TP.Nome_TP_Servico [Descricao], 
	US.Nome_Usuario [Usuario], 
	TP.Ativo
FROM 
	Tipo_Servico TP 
	JOIN Usuario US ON TP.Cd_Usuario = us.Cd_Usuario
where
	(@Id_TP_Servico = 0 and TP.Id_TP_Servico like '%')
	or
	(TP.Id_TP_Servico  = @Id_TP_Servico )
	
GO
