SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spATL_NavioxViagem_Sel 'AG. CADASTRO DE NAVIO','','E'
--spATL_NavioxViagem_Sel 'AG. CADASTRO DE NAVIO','%','E'
CREATE PROCEDURE [dbo].[spATL_Navio_NrViagem_Sel]--'AG. CADASTRO DE NAVIO','E'
(
	@Nome_Navio		varchar(50),
	@Modal			varchar(1)
)
AS
select distinct V.nr_viagem from Viagem_LLP V 
	left Join navio_LLP NV on V.id_navio = NV.Id_Navio 
where 
	Nome_Navio =@Nome_Navio
	and Modal = @Modal


GO
