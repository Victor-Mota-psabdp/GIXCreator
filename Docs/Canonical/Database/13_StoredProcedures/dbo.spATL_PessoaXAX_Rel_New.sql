SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_PessoaXAX_Rel_New]--'ALL'
(
	@ALL as Varchar(3)
)
as
Select
		(Case when AX.tipo = 'C' then 'Customer'
			when AX.tipo = 'F' then 'Vendor' 
			end) [Customer / Cliente],
		PP.Cd_pes							[Code],
		PP.Apelido							[Company Name (Short Name)],
		PP.Nome_Raz_Soc						[Complete Name],
		TA.Nome_tp_Ativ						[Type of Activity],
		TG.Nome_tp_Grupo					[Group Type],
		PP.Obs_PES							[Notes],
		PP.dt_cad							[Date],
		'Comercial'							[Type],
		EN.Numero							[Number],
		EN.compl_end						[Complement],
		EN.CEP								[ZIP],
		EN.Bairro							[Neighbourhood],
		EN.Cidade							[City],
		''[ST],
		EN.Pais								[Country],
		AX.cd_ax							[Cod. Amarração],
		PP.Num_Cpf_CNPJ						[CNPJ],
		GP.Apelido							[GRUPO],
		''						[Identificação para emissão de nota fiscal faturamento],
		UCP6.Nome_Usuario,
		CP3.Campo_Dados [Banco],
		CP5.Campo_Dados [Agencia],
		CP4.Campo_Dados [Codigo Banco],
		CP7.Campo_Dados [Conta Corrente],
		(Case when CP1.Campo_Dados = '1' then 'SIM'
			when CP1.Campo_Dados = '2' then 'NÂO' 
			end) [Crédito],
		CP13.Campo_Dados [EMIX - ID_CNPJ],
		CP12.Campo_Dados [EMIX - ID_Empresa],
		(Case when CP9.Campo_Dados = '1' then 'SIM'
			when CP9.Campo_Dados = '2' then 'NÂO' 
			end) [Envio de NF BDP Automático],
		(Case when CP8.Campo_Dados = '1' then 'SIM'
			when CP8.Campo_Dados = '2' then 'NÂO' 
			end)[Envio de Recibo Automático],
		(Case when CP2.Campo_Dados = '1' then 'SIM'
		when CP2.Campo_Dados = '2' then 'NÂO' 
		end) [Envio para o BDP Smart],
		CP15.Campo_Dados [I-broker - Exportador],
		CP14.Campo_Dados [I-broker - Importador],
		(Case when CP11.Campo_Dados = '1' then 'SIM'
		when CP11.Campo_Dados = '2' then 'NÂO' 
		end) [Prestação Sem Serviço BDP],
		(Case when CP10.Campo_Dados = '1' then 'SIM'
		when CP10.Campo_Dados = '2' then 'NÂO' 
		end) [Split Nota de Debito]
		
		
	from Pessoa PP with(nolock)
		Left  Join Endereco		EN with(nolock) on PP.cd_pes=EN.cd_pes  and EN.cd_tp_end='COM'
		Left  Join Tipo_Atividade	TA with(nolock) on TA.cd_tp_ativ=PP.cd_tp_ativ
		Left  Join Tipo_Grupo 		TG with(nolock) on TG.cd_tp_grupo=PP.cd_tp_grupo
		Left  Join Pessoa_LLP		LLP with(nolock) on PP.Cd_Pes = LLP.Cd_Pes
		Left  Join Pessoa			GP with(nolock) on LLP.Cd_Pes_Grupo = GP.Cd_Pes
		left  join Pessoa_Atl_Ax	AX with(nolock) on AX.cd_pes = PP.cd_pes
		left join  Campo_Pessoa CP6 with(nolock) on PP.Cd_Pes = CP6.Cd_Pes and CP6.Id_Campo = '6'
		left join Usuario UCP6 with(nolock) on CP6.Campo_Dados = UCP6.Cd_Usuario 
		left join  Campo_Pessoa CP3 with(nolock) on PP.Cd_Pes = CP3.Cd_Pes and CP3.Id_Campo = '3'
		left join  Campo_Pessoa CP5 with(nolock) on PP.Cd_Pes = CP5.Cd_Pes and CP5.Id_Campo = '5'
		left join  Campo_Pessoa CP4 with(nolock) on PP.Cd_Pes = CP4.Cd_Pes and CP4.Id_Campo = '4'
		left join  Campo_Pessoa CP7 with(nolock) on PP.Cd_Pes = CP7.Cd_Pes and CP7.Id_Campo = '7'
		left join  Campo_Pessoa CP1 with(nolock) on PP.Cd_Pes = CP1.Cd_Pes and CP1.Id_Campo = '1'
		left join  Campo_Pessoa CP13 with(nolock) on PP.Cd_Pes = CP13.Cd_Pes and CP13.Id_Campo = '13'
		left join  Campo_Pessoa CP12 with(nolock) on PP.Cd_Pes = CP12.Cd_Pes and CP12.Id_Campo = '12'
		left join  Campo_Pessoa CP9 with(nolock) on PP.Cd_Pes = CP9.Cd_Pes and CP9.Id_Campo = '9'
		left join  Campo_Pessoa CP8 with(nolock) on PP.Cd_Pes = CP8.Cd_Pes and CP8.Id_Campo = '8'
		left join  Campo_Pessoa CP2 with(nolock) on PP.Cd_Pes = CP2.Cd_Pes and CP2.Id_Campo = '2'
		left join  Campo_Pessoa CP15 with(nolock) on PP.Cd_Pes = CP15.Cd_Pes and CP15.Id_Campo = '15'
		left join  Campo_Pessoa CP14 with(nolock) on PP.Cd_Pes = CP14.Cd_Pes and CP14.Id_Campo = '14'
		left join  Campo_Pessoa CP11 with(nolock) on PP.Cd_Pes = CP11.Cd_Pes and CP11.Id_Campo = '11'
		left join  Campo_Pessoa CP10 with(nolock) on PP.Cd_Pes = CP10.Cd_Pes and CP10.Id_Campo = '10'
	Where
		PP.Desat_Pes = 'N'

	Order by
		2
		
OPTION(HASH JOIN)
GO
