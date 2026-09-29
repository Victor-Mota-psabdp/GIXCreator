SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spReportPedro_tmp]
		@Tipo_taxa Varchar(30),
		@Cia varchar(10)
as
Declare @resultado float
Declare @resultado_Tmp float

Declare Cur_Temp cursor for 
	select
		cast((dbo.fbusca_custo_processo(tf.num_proc,@Tipo_Taxa)) as decimal(10,2)) Valor 
	from
		tarefas_processos TF
		Join Pedido_Ship PS on Ps.num_proc=tf.num_proc
		Join Pedido PD on PD.cd_pedido=PS.cd_pedido
		Left Join House_imp_mar HIM ON HIM.NUM_PROC_HIM=TF.NUM_PROC
		Left Join House_imp_AER HIA ON HIA.NUM_PROC_HIA=TF.NUM_PROC
		Left Join House_IMP_OUT HIO ON HIO.NUM_PROC_HIO=TF.NUM_PROC
		LEFT JOIN PESSOA_LLP LLP ON (LLP.CD_PES=CD_CONSIG_HIA OR LLP.CD_PES=CD_CONSIG_HIM OR LLP.CD_PES=CD_CONSIG_HIO) and LLP.Cd_Pes_Grupo='1'
	where 
		id_task=4 
		and year(dt_conclusao)=2008 
		and RIGHT(LEFT(ISNULL(PLANTA,LLP.CD_PLANTA),5),2) like @Cia
		and RIGHT(LEFT(ISNULL(PLANTA,LLP.CD_PLANTA),5),2) is not null
		and RIGHT(LEFT(ISNULL(PLANTA,LLP.CD_PLANTA),5),2) <>''
	Group by 
		tf.num_proc,RIGHT(LEFT(ISNULL(PLANTA,LLP.CD_PLANTA),5),2)

Set @resultado=0
Set @resultado_tmp = 0
Open Cur_temp
	fetch Next from Cur_Temp into @resultado_tmp
	While @@fetch_status=0
		Begin
			Set @resultado=@resultado+@resultado_tmp
			fetch Next from Cur_Temp into @resultado_tmp
		End
	Close Cur_temp
	deallocate Cur_temp
select @resultado Valor_Final 
	

GO
