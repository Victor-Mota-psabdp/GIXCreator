SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spExtratoLAMA]

as


select Titular,'MA' Tipo, convert(Datetime,Dt_pgto_rcto_mov,105) data, Num_Lcto_mov, dbo.valor(vlr_doc_mov,dc_mov) Valor, Dc_mov, 'Banco'  Cia from mvto_cta_cte pg
Join Cta_Cte CTA on CTA.cd_banco=pg.cd_banco and cta.cd_agencia=pg.cd_agencia and cta.num_cta_cte=pg.num_cta_cte
Where convert(Datetime,dt_pgto_rcto_mov,105) >=getdate()-1

UNION

SELECT Titular,'LA',convert(Datetime,DT_PGTO_RCTO,105) Data ,NUM_LCTO,DBO.VALOR(VLR_DOC,DC),dc,apelido FROM PGTO_RCTO PC
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte

Where convert(Datetime,dt_pgto_rcto,105)>=getdate()-1

union


SELECT Titular,'LA',convert(datetime,DT_PGTO_RCTO_div,105),NUM_LCTO_div,DBO.VALOR(VLR_DOC_div,DC_div),dc_div,apelido FROM PGTO_RCTO_div PC
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte
Where convert(Datetime,dt_pgto_rcto_div,105)>=getdate()-1


UNION 

SELECT Titular, 'LA',convert(datetime,DT_RA,105),NUM_REF_RA,VLR_TOT_FCHTO_RA,'R',APELIDO FROM REMESSA_AER PC
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Where convert(Datetime,DT_RA,105)>=getdate()-1

UNION

SELECT Titular, 'LA',convert(Datetime,DT_RM,105),NUM_REF_RM,VLR_TOT_FCHTO_RM,'R',APELIDO FROM REMESSA_MAR PC
Join Cta_Cte CTA on CTA.cd_banco=pc.cd_banco and cta.cd_agencia=pc.cd_agencia and cta.num_cta_cte=pc.num_cta_cte
Join Pessoa PP on PP.cd_pes=PC.cd_pes
Where convert(Datetime,DT_RM,105)>=getdate()-1




GO
