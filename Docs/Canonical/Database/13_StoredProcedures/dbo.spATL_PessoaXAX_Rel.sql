SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_PessoaXAX_Rel]-- 'ALL'
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
		''						[Identificação para emissão de nota fiscal faturamento]



	from Pessoa PP with(nolock)
		Left  Join Endereco			EN with(nolock) on PP.cd_pes=EN.cd_pes  and EN.cd_tp_end='COM'
		Left  Join Tipo_Atividade	TA with(nolock) on TA.cd_tp_ativ=PP.cd_tp_ativ
		Left  Join Tipo_Grupo 		TG with(nolock) on TG.cd_tp_grupo=PP.cd_tp_grupo
		Left  Join Pessoa_LLP		LLP with(nolock) on PP.Cd_Pes = LLP.Cd_Pes
		Left  Join	Pessoa			GP with(nolock) on LLP.Cd_Pes_Grupo = GP.Cd_Pes
		left  join Pessoa_Atl_Ax	AX with(nolock) on AX.cd_pes = PP.cd_pes
	Where
		PP.Desat_Pes = 'N'

	Order by
		2
		
OPTION(HASH JOIN)

--select * from pessoa_atl_ax where cd_ax = 1438
--select * from pessoa_atl_ax where cd_ax = 838
GO
