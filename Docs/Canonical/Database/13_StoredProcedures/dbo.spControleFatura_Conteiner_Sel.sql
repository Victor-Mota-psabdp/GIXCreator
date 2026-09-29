SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spControleFatura_Conteiner_Sel]--'IMATL201109005BR','900001/2012'
	@Job	Varchar(16),
	@cd_controlefatura varchar(11)
AS

if @cd_controlefatura = ''
	Begin
		select			
			(case when Active is null then convert(bit,0) else Active end) Active,
			Num_cont_im		[Container], 
			CM.Num_lacre_IM [Seal],
			isnull(valor_container,0) [Value],			
			CM.dt_devol_im			[Return Date]  
		from container_hou_imp_mar CC
			join container_mas_imp_mar CM on cm.num_proc_mim = CC.num_proc_mim and CM.item_cont_im = CC.item_cont_im 
			join tipo_container TC on TC.cd_tp_cont = CM.cd_tp_cont
			left join controle_fatura CF on cf.num_proc = num_proc_him
			left join Controle_Fatura_Container CFC on CFC.container = num_cont_im and cfc.cd_controlefatura = cf.cd_controlefatura
		where num_proc_him = @Job
		and cfc.cd_controlefatura is null 
	End
Else
	Begin
		select 
			(case when Active is null then convert(bit,0) else Active end) Active,
			Num_cont_im		[Container], 
			CM.Num_lacre_IM [Seal],
			isnull(valor_container,0) [Value],
			CM.dt_devol_im [Return Date]  
		from container_hou_imp_mar CC
			join container_mas_imp_mar CM on cm.num_proc_mim = CC.num_proc_mim and CM.item_cont_im = CC.item_cont_im 
			join tipo_container TC on TC.cd_tp_cont = CM.cd_tp_cont
			left join controle_fatura CF on cf.num_proc = num_proc_him
			left join Controle_Fatura_Container CFC on CFC.container = num_cont_im and cfc.cd_controlefatura = cf.cd_controlefatura
		where num_proc_him = @Job
		and cfc.cd_controlefatura = @cd_controlefatura
	End
	
GO
