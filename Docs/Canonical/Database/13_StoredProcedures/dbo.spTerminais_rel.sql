SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   Procedure [dbo].[spTerminais_rel] --'01-03-2010','30-03-2010','LOCAL FRIO'
		
		@DataInicial Char (10),
		@DataFinal Char(10),
		@Terminal Varchar(50)

as

Select 
	Nome_Terminal, PP.Apelido,Nome_tp_cont, hou.Num_proc_him,count(distinct cm.num_cont_im) Qty--,PC.Apelido Pessoa_CTA,Nome_Tp_tx, CTA.cd_tp_moeda,dc_him,dbo.valor(Vlr_org_him,dc_him) Valor
From 
	Master_Imp_mar MAS
	Join House_Imp_mar HOU on mas.num_proc_mim=hou.num_proc_mim
	Join Terminal TM on (TM.cd_terminal= isnull(MAS.cd_terminal,(select campo_dados from campo_processo where id_campo='2' and num_proc=HOU.num_proc_him)))
	Join Container_Hou_Imp_MAr CH on CH.num_proc_him=hou.num_proc_him
	Join Container_Mas_Imp_MAR CM on CM.num_proc_mim=CH.num_proc_mim and CM.Item_cont_im=CH.item_cont_im
	Join Tipo_container TC on Tc.cd_tp_cont=CM.cd_Tp_cont
	Join Pessoa PP on PP.cd_pes=cd_import_him

Where
	cm.cd_tp_cont not in ('LCL','LCM')
	and convert(Datetime,dt_atrac_mim,105) between convert(datetime,@DataInicial,103) and convert(datetime,@DataFinal,103)
	and Nome_terminal like @Terminal
	
Group by
	Nome_Terminal, PP.Apelido,Nome_tp_cont,hou.num_proc_him--, PC.Apelido,Nome_Tp_tx, CTA.cd_tp_moeda,dc_him,Vlr_org_him 	



GO
