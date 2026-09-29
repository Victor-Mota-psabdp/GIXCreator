SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spTermoContainerGW_Rel]--'IMHYU201107008BR'
	@JOB varchar(16)
as
	select
		HOU.Num_Proc_HIM JOB,
		Upper(HOU.Navio_HIM) Navio, 
		upper(Viagem_HIM) Viagem, 
		upper(ORG.Nome_Local) Origem, 
		Upper(DST.Nome_Local) Destino, 
		HOU.HAWB_HIM Conhecimento,
		HOU.MAWB_HIM Master, 
		LLP.ATA_LIM ATA, 
		dbo.fBusca_Containers(@JOB) Containers,
		Upper(CNS.Nome_Raz_Soc) Cons_RazaoS, 
		CNS.Num_cpf_cnpj Cons_CNPJ, 
		Upper(CNSE.Rua) + ', ' + CNSE.numero Endereco,
		Upper(CNSE.Cidade) + '/' + Upper(CNSE.UF) Cidade,
		CNSE.CEP		
	from
		House_Imp_Mar HOU
		join LLP_Imp_Mar LLP on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		left Join Localidade ORG on ORG.cd_local = HOU.cd_org_him
		left Join Localidade DST on DST.cd_local = HOU.cd_dst_him
		join Pessoa CNS on CNS.cd_pes = HOU.cd_consig_him
		left join endereco CNSE on CNSE.cd_pes = CNS.cd_pes and CNSE.cd_tp_end = 'COM'
		left join comunicacao CT on CT.cd_pes = CNS.cd_pes
	where 
		HOU.Num_Proc_HIM = @JOB --'IMCAR20090600801'




GO
