SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from vwCliente_Alerta where num_proc like 'BOCSR202011006BR%'
--select * from [vwNF_Fatura_Sel] where [JOB] like 'BOCSR202011006BR%'
--select * from NF_Fatura_Item where  num_proc like 'BOCSR202011006BR%'
--cadu 23/12/2021 - Alterei para 3 anos


CREATE VIEW [dbo].[vwNF_Fatura_Sel]

AS

select 	
	Numero_fat							[Invoice Number],
	HOU.num_proc						[JOB],
	NF.Nota_Fiscal						[NF Number],
	B.RPS_NFE							[NFe Number],
	ST.Cd_Site + ' - ' +ST.Nome_Site	[Invoice Type],
	PS.apelido							[Company Name(Short Name)],
	Nome_Raz_Soc						[Company Name(Full Name)],	
	NF.Emissao							[Invoice Date],
	NF.Vencimento						[Due Date]
	--NF.cd_status,
	--NF.Total_NF,
	--NF.Total_FAT, 
	--NF.Observ_nf, 
	--NF.Aliq_ISS, 
	--NF.Valor_ISS,
	--NF.Habilita_Impostos,
	--NF.Atencao,
	--NF.cd_servico,NF.descricao,NF.item_lei,NF.CNAE,NF.IRRF_Tx,
	--FatVendorInvoiceNumber, --Alessandra 19/05/2021 - AX10		
from 
	NF_Fatura NF
	join NF_Fatura_Item NFI on NFI.id = NF.ID
	join vwCliente_Alerta HOU on NFI.num_proc = HOU.Num_Proc
	left join Pessoa PS with(nolock) on NF.cd_pes = PS.cd_pes
	left join Endereco ED with(nolock) on NF.cd_Pes = ED.cd_pes
	left join Site ST with(nolock) on NF.Ref_Acesso = ST.Cd_Site
	left join Base_Nota_Fiscal B on B.Nota_Fiscal = NF.Nota_Fiscal and B.Ref_Acesso = NF.Ref_Acesso 
where 
	year(NF.Emissao) > year(Getdate()) -3


--SELECT 
--	I.Num_Proc,I.Cd_Tp_Tx,I.DC,Cd_tp_Moeda,Vlr_Org,Paridade,Vlr_RS,Vlr_Iva,Vlr_Cont_Item,ONF,RTX, 
--	F.Numero_Fat,F.Nota_Fiscal,F.Ref_Acesso,F.Emissao,F.Cd_Pes,F.Num_CPF_CNPJ,F.Num_RG_IE,F.Razao_Social,F.Endereco,F.Numero,F.Bairro,F.Cep,F.Cidade,F.UF,F.Pais,
--	F.Tipo_Serv,F.Condicoes,F.Prazo,F.Cd_Status,F.Total_NF,F.Total_FAT,F.Observ_NF,F.Aliq_ISS,F.Valor_ISS,F.ISS_Retido,
--	F.RPS_Data,F.RPS_NFE,F.RPS_NFE_Verif,F.CdsId,F.SitId,F.Aliq_ISS_Rps,F.RPS_Envio,F.cd_usuario_cancel,F.Habilita_Impostos,
--	F.Cd_Usuario,F.Dt_Canc,F.Dt_Cont_Canc,F.dt_envio_ax,F.dt_envio_canc_ax,F.Vencimento,F.Atencao,F.cd_servico,F.Item_lei
--	,F.CNAE,F.Descricao
--FROM  dbo.NF_Fatura AS F INNER JOIN
--            dbo.NF_Fatura_Item AS I ON I.ID=F.ID 
--WHERE
--	(isnull(cd_status,0) <> 2)


GO
