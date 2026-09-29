SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spContainerAdditionalInfo_Sel] (
@Num_Proc varchar(16),
@Num_Cont varchar(50)
)
as

select 
	dt_entregaPlanta,
	dt_entregaArmazem,
	dt_saidaArmazem,
	dt_saidavazio,
	local_entrega,
	local_entrega_vazio,
	dt_devolucao,
	mercadoria,
	Peso_Bruto_EM_VGM,
	UOM_VGM,
	Dt_Envio_VGM,
	Nome_Responsavel_VGM, 
	(Case when metodo_vgm = 1 then '1-Weighing Packed Container'else  Case when metodo_vgm = 2 then '2-Weighing All Packages and Cargo Items' else '' End End) metodo_vgm  ,
	TatcNumber,
	dt_ReleaseTatc,
	Itinerary_ID --Alessandra 07/07/2020 - e-mail TESTE SCHNEIDER EXPORTAÇÃO MARÍTIMA RM X ABERTURA DE JOB x CONSOLIDADA TRANSPORTATION
	from container_additional_info with(nolock) where ativo = 1 and num_proc = @Num_Proc and num_cont =  @Num_Cont
GO
