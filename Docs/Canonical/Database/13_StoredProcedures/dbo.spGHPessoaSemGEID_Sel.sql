SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spGHPessoaSemGEID_Sel]


AS

/*
	Stored utilizada para busca de importadores e exportadores que não tenha o Codigo Global Informado (GEID)
		

*/

Select 
	Distinct P.Cd_Pes,Nome_Raz_Soc,Cidade,UF,CEP,Pais,SCAC, (RUA + ' , ' + Isnull(numero,'') + ' '  + Isnull(Compl_End,'')) Endereco,isnull(Cd_Pais,'BR') Cd_Pais
From
	Pessoa P With(nolock)
	Join Endereco E with(nolock) on E.cd_pes=P.cd_pes
	Join vwcliente VWC with(nolock)  on VWC.cd_cliente=P.cd_pes
Where
	GLOBAL_ENTITY_ID is null
	And 
	SCAC is not null
	and 
	cd_pais='BR'
	---and apelido='CORBION - 3961C'

	


GO
