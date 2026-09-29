SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spIntPessoa_Sel 'P18938' 
--18072023-cadu - included [RemoveNonAlphaCharacters]
--18/08/2023 Cadu - [FRemoveAcentuacao] - Update to not send the accentuation 
CREATE Procedure [dbo].[spIntPessoa_Sel]
		(
			@cd_pes 	Varchar(10)
		
		)
as

	Select 
		Isnull(Smart_Imp,@Cd_Pes) Smart_IMP,
		isnull(Smart_Exp,@Cd_Pes) Smart_Exp,
		pp.cd_pes codigo,
		pp.nome_raz_soc,
		--*,

		[dbo].[FRemoveAcentuacao](Rua+ ' ' + Isnull(numero,'') + ' ' + Isnull(Compl_end,'')) Endereco,
		[dbo].[FRemoveAcentuacao](Cidade) Cidade,

		--Rua+ ' ' + Isnull(numero,'') + ' ' + Isnull(Compl_end,'') Endereco,
		--Cidade,
		
		
		LLP.cd_pes_grupo,
		cd_vendor,
		pp.cd_pes, 
		(Isnull(Prefixo,'') + '-' + Isnull(Num_Fone,'')) as Telefone,
		num_cpf_CNPJ CNPJ,
		pp.GLOBAL_ENTITY_ID,
		ed.uf,
		ed.cep,
		Pais,
		Isnull(cd_pais,'') cd_pais,
		Isnull(scac,'') SCAC,
		Isnull(unit,'CSA') Unit,
		COM.Contato,
		COM.Compl_Fone Email,
		LLP.Cd_Vendor,
		LLP.planta_nome
	from pessoa PP with(nolock)
		Left Join Endereco ED with(nolock) on PP.cd_pes=ED.cd_pes and cd_Tp_end='COM'
		Left Join Pessoa_LLP LLP with(nolock) on PP.cd_pes=LLP.cd_pes
		Left Join Comunicacao COM with(nolock) on PP.cd_pes=COM.cd_pes AND CD_TP_COM='TC1'
		Left Join Grupo GRP with(nolock) on GRP.cd_pes_Grupo=LLP.cd_pes_Grupo
	Where  pp.cd_pes =@cd_pes




















GO
