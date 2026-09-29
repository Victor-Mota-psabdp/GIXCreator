SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_SOLAS_Container_REL]--'EMATL201601001BR'
(
	@Num_Proc varchar(16)
)

as

Declare @cd_tp_carga as int
set @cd_tp_carga =(select Cd_Tp_Carga from vwHouse_Exp LEM where Num_Proc =@Num_Proc )


if @cd_tp_carga = 1
	select 	
		CAi.num_cont,	
		CAI.Peso_Bruto_EM_VGM [Gross Weight VGM],
		LEM.DL_VGM [DeadLine VGM] ,
		CAI.UOM_VGM [UOM VGM],	 
		REPLACE(CONVERT(NVARCHAR,CAI.Dt_Envio_VGM, 106), ' ', '-') [Reported VGM],
		CAI.Nome_Responsavel_VGM [AUTORIZED PERSON],
		'Method ' + convert(varchar(2),Cai.Metodo_VGM) Metodo_VGM
	from Container_Hou_Exp_mar CH with(nolock)
		join Container_Mas_Exp_Mar CM with(nolock) on CH.Num_Proc_MEM = CM.Num_Proc_MEM and CH.Item_Cont_EM = CM.Item_Cont_EM
		left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc and CAI.num_cont = replace(CM.num_cont_em,'-','')	
		join vwHouse_Exp LEM with(nolock) on CAI.num_proc = LEM.Num_Proc
	where 
		CH.Num_Proc_HEM = @Num_Proc
Else
	select 	
		'LCL' num_cont,	
		sum(CAI.Peso_Bruto_EM_VGM) [Gross Weight VGM],		
		--CAI.UOM_VGM 
		''[UOM VGM],	 
		--REPLACE(CONVERT(NVARCHAR,CAI.Dt_Envio_VGM, 106), ' ', '-') 
		''[Reported VGM],
		--CAI.Nome_Responsavel_VGM 
		''[AUTORIZED PERSON],
		--'Method ' + convert(varchar(2),Cai.Metodo_VGM) 
		''Metodo_VGM
	from Container_Hou_Exp_mar CH with(nolock)
		join Container_Mas_Exp_Mar CM with(nolock) on CH.Num_Proc_MEM = CM.Num_Proc_MEM and CH.Item_Cont_EM = CM.Item_Cont_EM
		left join Container_Additional_Info CAI with(nolock) on CH.Num_Proc_HEM = CAI.num_proc and CAI.num_cont = replace(CM.num_cont_em,'-','')			
	where 
		CH.Num_Proc_HEM = @Num_Proc
	--Group by
	--	CAI.UOM_VGM,CAI.Dt_Envio_VGM,CAI.Nome_Responsavel_VGM,Cai.Metodo_VGM 
		
	


GO
