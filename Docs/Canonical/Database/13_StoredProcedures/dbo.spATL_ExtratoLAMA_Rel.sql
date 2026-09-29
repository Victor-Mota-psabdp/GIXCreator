SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spATL_ExtratoLAMA_Rel]
	@DtInicial datetime,
	@DtFinal datetime
as

select Titular,'MA' Tipo, convert(Datetime,Dt_pgto_rcto_mov,105) data, Num_Lcto_mov [Num Lcto], dbo.valor(vlr_doc_mov,dc_mov) Valor, Dc_mov [D/C], 'Banco'  [Credor/Devedor] from mvto_cta_cte pg
Join Cta_Cte CTA on CTA.cd_banco=pg.cd_banco and cta.cd_agencia=pg.cd_agencia and cta.num_cta_cte=pg.num_cta_cte
Where convert(Datetime,dt_pgto_rcto_mov,105) between @DtInicial and @DtFinal

UNION ALL

SELECT Titular,'LA',convert(Datetime,DT_PGTO_RCTO,105) Data ,NUM_LCTO,DBO.VALOR(VLR_DOC,DC),dc,apelido FROM PGTO_RCTO PC
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte

Where convert(Datetime,dt_pgto_rcto,105) between @DtInicial and @DtFinal

union ALL

SELECT Titular,'LA',convert(datetime,DT_PGTO_RCTO_div,105),NUM_LCTO_div,DBO.VALOR(VLR_DOC_div,DC_div),dc_div,apelido FROM PGTO_RCTO_div PC
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte
Where convert(Datetime,dt_pgto_rcto_div,105) between @DtInicial and @DtFinal


UNION ALL

SELECT Titular, 'LA',convert(datetime,DT_RA,105),NUM_REF_RA,VLR_TOT_RA *-1, (case when VLR_TOT_FCHTO_RA <=0 then 'C' else 'D' end),APELIDO FROM REMESSA_AER PC
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Where convert(Datetime,DT_RA,105) between @DtInicial and @DtFinal

UNION ALL

SELECT Titular, 'LA',convert(Datetime,DT_RM,105),NUM_REF_RM,VLR_TOT_RM *-1,(case when VLR_TOT_FCHTO_RM <=0 then 'C' else 'D' end),APELIDO FROM REMESSA_MAR PC
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Where convert(Datetime,DT_RM,105) between @DtInicial and @DtFinal





GO
