SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spEnvioInvoice_Rel]

as

select HSGPROCESSO + '_002.pdf' DOC, Num_Invoice from hist_geral HG
left outer join Invoice_Cliente IC on HG.HSGPROCESSO = IC.Num_proc
where convert(varchar,HSGDATA,103) = convert(varchar,getdate(),103) and cd_tp_ocor = 63 and HSGDATACONF is null
group by HSGPROCESSO, Num_Invoice




GO
