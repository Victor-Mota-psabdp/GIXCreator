SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRelacaoSynchro_Alerta]

as

select Numero_PO_HIM PO,num_proc,nota_fiscal from nota_cliente NC with(nolock)
left join PO_HIM PO with(nolock) on PO.Num_Proc_him = NC.Num_Proc and ID_DC = '1'
where   emissao > '01-01-2010' and envio = 'S'  and nota_fiscal <> '1' 
and (num_proc like '%CSR%' or num_proc like '%STB%') and left(NC.num_proc,2)='IM' and convert(varchar(10),Data_Envio,112) = convert(varchar(10),getdate(),112)

union

select Numero_PO_HIA PO,num_proc,nota_fiscal from nota_cliente NC with(nolock)
left join PO_HIA PO with(nolock) on PO.Num_Proc_hia = NC.Num_Proc and ID_DC = '1'
where   emissao > '01-01-2010' and envio = 'S' and nota_fiscal <> '1' 
and (num_proc like '%CSR%' or num_proc like '%STB%') and left(NC.num_proc,2)='IA' and convert(varchar(10),Data_Envio,112) = convert(varchar(10),getdate(),112)

union

select Numero_PO_HIO PO,num_proc,nota_fiscal from nota_cliente NC with(nolock)
left join PO_HIO PO with(nolock) on PO.Num_Proc_hio = NC.Num_Proc and ID_DC = '1'
where   emissao > '01-01-2010' and envio = 'S' and nota_fiscal <> '1' 
and (num_proc like '%CSR%' or num_proc like '%STB%') and left(NC.num_proc,2)='IO' and convert(varchar(10),Data_Envio,112) = convert(varchar(10),getdate(),112)


GO
