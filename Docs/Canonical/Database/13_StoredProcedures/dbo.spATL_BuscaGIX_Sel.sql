SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaGIX_Sel](
@Type varchar(2)
)
as


select ID, Num_Proc Processo, Type,Dt_Ins, Dt_Send,Cd_Usuario,Tipo_Envio from Exchange_GTNEXUS
where Dt_Send is null and Type = @Type 

--select top 1 ID, Num_Proc Processo, Type,Dt_Ins, Dt_Send,Cd_Usuario,Tipo_Envio from Exchange_GTNEXUS
--where  Num_Proc = 'EMCSR201705207BR'

--select * from GTNEXUS_XML
--where Num_Proc = 'EMCSR201607012BR'
GO
