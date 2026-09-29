SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_View_Volume_Modal_Sel]
@Processo	varchar(16),
@ItemCont   varchar(15),
@tipo       varchar(1)
AS
if @Tipo ='A' 
		Begin 
			Select
				HOU.Num_Proc_HEM         [Job],
				Item_EM                  [Item],
				Qtd_Vol_EM               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_EM                 [Comprimento],
				Largura_EM               [Largura],
				Altura_EM                [Altura],
				HOU.Vol_Item_EM          [Vol_Item],
				HOU.Peso_Bruto_EM        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_EM                 [Marca],
				Contra_Marca             [Contra_Marca],
				MAS.Num_Cont_EM          [Numero_Container],
				HOU.Item_Cont_EM         [Item_Cont]
			From
				Volume_Exp_Mar	HOU with(nolock)
				Join	Tipo_Embalagem	TE with(nolock) on TE.cd_tp_embal = HOU.cd_tp_embal
				Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
				Join	NCM		N  with(nolock) on N.Id_NCM = HOU.Id_NCM
				Left Join Container_Hou_Exp_Mar CH with(nolock) on HOU.Num_Proc_HEM = CH.Num_Proc_HEM and HOU.Item_Cont_EM = CH.Item_Cont_EM   
				Left Join Container_Mas_Exp_Mar MAS with(nolock) on MAS.Num_Proc_MEM = CH.Num_Proc_MEM and MAS.Item_Cont_EM = CH.Item_Cont_EM   
			Where
				HOU.num_proc_HEM=@Processo
		union all 
			Select
				HOU.Num_Proc_HEA         [Job],
				Item_EA                  [Item],
				Qtd_Vol_EA               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_EA                 [Comprimento],
				Largura_EA               [Largura],
				Altura_EA                [Altura],
				HOU.Vol_Item_EA          [Vol_Item],
				HOU.Peso_Bruto_EA        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_EA                 [Marca],
				Contra_Marca             [Contra_Marca],
				''                       [Numero_Container],
				''                       [Item_Cont]
			From
			Volume_Exp_Aer	HOU
			Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
			Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
			Join	NCM		N  on N.Id_NCM = HOU.Id_NCM
			Where
				num_proc_HEA=@Processo
		union all 
			Select
				HOU.Num_Proc_HEO         [Job],
				Item_EO                  [Item],
				Qtd_Vol_EO               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_EO                 [Comprimento],
				Largura_EO               [Largura],
				Altura_EO                [Altura],
				HOU.Vol_Item_EO          [Vol_Item],
				HOU.Peso_Bruto_EO        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_EO                 [Marca],
				Contra_Marca             [Contra_Marca],
				''                       [Numero_Container],	
				''                       [Item_Cont]
				From
				Volume_Exp_OUT	HOU
			Left Outer Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
			Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
			Left Outer Join	NCM		N  on N.Id_NCM = HOU.Id_NCM
			Where
				num_proc_HEO=@Processo
		union all
			Select distinct
				HOU.Num_Proc_HIM         [Job],
				Item_IM                  [Item],
				Qtd_Vol_IM               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_IM                 [Comprimento],
				Largura_IM               [Largura],
				Altura_IM                [Altura],
				HOU.Vol_Item_IM          [Vol_Item],
				HOU.Peso_Bruto_IM        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_IM                 [Marca],
				Contra_Marca             [Contra_Marca],
				MAS.Num_Cont_IM          [Numero_Container],
				HOU.Item_Cont_IM         [Item_Cont]
			From
				Volume_Imp_Mar	HOU
				Join Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
				Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
				Join NCM N on N.Id_NCM = HOU.Id_NCM
				Left Outer Join Container_Hou_Imp_Mar CH on HOU.Num_Proc_HIM = CH.Num_Proc_HIM and HOU.Item_Cont_IM = CH.Item_Cont_IM   
				LEFT Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM   
			Where
				HOU.num_proc_HIM=@Processo
		union all 
		Select
				HOU.Num_Proc_HIA         [Job],
				Item_IA                  [Item],
				Qtd_Vol_IA               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_IA                 [Comprimento],
				Largura_IA               [Largura],
				Altura_IA                [Altura],
				HOU.Vol_Item_IA          [Vol_Item],
				HOU.Peso_Bruto_IA        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_IA                 [Marca],
				Contra_Marca             [Contra_Marca],
				''                       [Numero_Container],
				''                       [Item_Cont]
			From
				Volume_Imp_Aer	HOU
			Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
			Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
			Join	NCM		N  on N.Id_NCM = HOU.Id_NCM

			Where
				num_proc_HIA=@Processo
		union all 
			Select
				HOU.Num_Proc_HIO         [Job],
				Item_IO                  [Item],
				Qtd_Vol_IO               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_IO                 [Comprimento],
				Largura_IO               [Largura],
				Altura_IO                [Altura],
				HOU.Vol_Item_IO          [Vol_Item],
				HOU.Peso_Bruto_IO        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_IO                 [Marca],
				Contra_Marca             [Contra_Marca],
				''                       [Numero_Container],
				''                       [Item_Cont]
			From
				Volume_Imp_OUT	HOU
			Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
			Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
			Join	NCM		N  on N.Id_NCM = HOU.Id_NCM
			Where
				num_proc_HIO=@Processo
		end 
if @Tipo ='B' 
		Begin 
			Select
				HOU.Num_Proc_HEM         [Job],
				Item_EM                  [Item],
				Qtd_Vol_EM               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_EM                 [Comprimento],
				Largura_EM               [Largura],
				Altura_EM                [Altura],
				HOU.Vol_Item_EM          [Vol_Item],
				HOU.Peso_Bruto_EM        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_EM                 [Marca],
				Contra_Marca             [Contra_Marca],
				MAS.Num_Cont_EM          [Numero_Container],
				HOU.Item_Cont_EM         [Item_Cont]
			From
				Volume_Exp_Mar	HOU with(nolock)
				Join	Tipo_Embalagem	TE with(nolock) on TE.cd_tp_embal = HOU.cd_tp_embal
				Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
				Join	NCM		N  with(nolock) on N.Id_NCM = HOU.Id_NCM
				Left Join Container_Hou_Exp_Mar CH with(nolock) 
				on HOU.Num_Proc_HEM = CH.Num_Proc_HEM 
				and HOU.Item_Cont_EM = CH.Item_Cont_EM   
				Left Join Container_Mas_Exp_Mar MAS with(nolock) 
				on MAS.Num_Proc_MEM = CH.Num_Proc_MEM 
				and MAS.Item_Cont_EM = CH.Item_Cont_EM   
			Where
				HOU.num_proc_HEM=@Processo
			AND MAS.Num_Cont_EM = @ItemCont
		union all
			Select distinct
				HOU.Num_Proc_HIM         [Job],
				Item_IM                  [Item],
				Qtd_Vol_IM               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_IM                 [Comprimento],
				Largura_IM               [Largura],
				Altura_IM                [Altura],
				HOU.Vol_Item_IM          [Vol_Item],
				HOU.Peso_Bruto_IM        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_IM                 [Marca],
				Contra_Marca             [Contra_Marca],
				MAS.Num_Cont_IM          [Numero_Container],
				HOU.Item_Cont_IM         [Item_Cont]
			From
				Volume_Imp_Mar	HOU
				Join Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
				Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
				Join NCM N on N.Id_NCM = HOU.Id_NCM
				Left Outer Join Container_Hou_Imp_Mar CH on HOU.Num_Proc_HIM = CH.Num_Proc_HIM and HOU.Item_Cont_IM = CH.Item_Cont_IM   
				LEFT Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM   
			Where
				HOU.num_proc_HIM=@Processo
			AND MAS.Num_Cont_IM = @ItemCont
END 

if @Tipo ='D'  --Created to Draft BL 08/06/2026 Leandro
		Begin 
			Select
				HOU.Num_Proc_HEM         [Job],
				Item_EM                  [Item],
				Qtd_Vol_EM               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_EM                 [Comprimento],
				Largura_EM               [Largura],
				Altura_EM                [Altura],
				HOU.Vol_Item_EM          [Vol_Item],
				HOU.Peso_Bruto_EM        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_EM                 [Marca],
				Contra_Marca             [Contra_Marca],
				MAS.Num_Cont_EM          [Numero_Container],
				HOU.Item_Cont_EM         [Item_Cont]
			From
				Volume_Exp_Mar	HOU with(nolock)
				Join	Tipo_Embalagem	TE with(nolock) on TE.cd_tp_embal = HOU.cd_tp_embal
				Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
				Join	NCM		N  with(nolock) on N.Id_NCM = HOU.Id_NCM
				Left Join Container_Hou_Exp_Mar CH with(nolock) 
				on HOU.Num_Proc_HEM = CH.Num_Proc_HEM 
				and HOU.Item_Cont_EM = CH.Item_Cont_EM   
				Left Join Container_Mas_Exp_Mar MAS with(nolock) 
				on MAS.Num_Proc_MEM = CH.Num_Proc_MEM 
				and MAS.Item_Cont_EM = CH.Item_Cont_EM   
			Where
				HOU.num_proc_HEM=@Processo
			AND MAS.Num_Cont_EM = @ItemCont
		union all
			Select distinct
				HOU.Num_Proc_HIM         [Job],
				Item_IM                  [Item],
				Qtd_Vol_IM               [Qtd_Vol],
				hou.Cd_Tp_Embal          [Cd_Tp_Embal],
				Nome_Tp_Embal            [Nome_Tp_Embal],
				tu.Cd_Tp_Unidade         [Cd_Tp_Unidade],
				Compr_IM                 [Comprimento],
				Largura_IM               [Largura],
				Altura_IM                [Altura],
				HOU.Vol_Item_IM          [Vol_Item],
				HOU.Peso_Bruto_IM        [Peso_Bruto],
				N.Id_NCM                 [Id_NCM],                 
				NCM                      [NCM],
				dbo.fNCM(@Processo)      [NCM_RPT],
				Marca_IM                 [Marca],
				Contra_Marca             [Contra_Marca],
				MAS.Num_Cont_IM          [Numero_Container],
				HOU.Item_Cont_IM         [Item_Cont]
			From
				Volume_Imp_Mar	HOU
				Join Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
				Join	Tipo_Unidade	TU with(nolock) on TU.Cd_Tp_Unidade = HOU.Cd_Tp_Unidade
				Join NCM N on N.Id_NCM = HOU.Id_NCM
				Left Outer Join Container_Hou_Imp_Mar CH on HOU.Num_Proc_HIM = CH.Num_Proc_HIM and HOU.Item_Cont_IM = CH.Item_Cont_IM   
				LEFT Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM   
			Where
				HOU.num_proc_HIM=@Processo
			AND MAS.Num_Cont_IM = @ItemCont
END 

GO
