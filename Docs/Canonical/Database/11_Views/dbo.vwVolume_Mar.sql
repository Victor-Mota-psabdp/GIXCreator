SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwVolume_Mar]
AS
SELECT VOL.Num_Proc_HIM Num_Proc , Item_IM Item, Qtd_Vol_IM Qtd_Vol, Compr_IM Compr, Largura_IM Largura, 
			Altura_IM Altura, Cd_Tp_Unidade , Vol_Item_IM Vol_Item, VOL.Id_NCM,NCM.NCM, VOL.Peso_Bruto_IM Peso_Bruto, 
			VOL.Cd_Tp_Embal,TC.Nome_Tp_Embal, Marca_IM Marca,Contra_Marca Contra_Marca, VOL.Item_Cont_IM Item_Cont,
			MAS.Num_Cont_IM Num_Cont
FROM	Volume_Imp_Mar VOL
		LEFT JOIN dbo.Container_Mas_Imp_Mar AS MAS WITH (nolock) ON VOL.Item_Cont_IM = MAS.Item_Cont_IM
		LEFT JOIN	dbo.Container_Hou_Imp_Mar AS HOU WITH (nolock) ON HOU.Item_Cont_IM = MAS.Item_Cont_IM  AND VOL.Num_Proc_HIM = HOU.Num_Proc_HIM
				AND MAS.Num_Proc_MIM = HOU.Num_Proc_MIM 
		LEFT JOIN dbo.Tipo_Embalagem AS TC  WITH (nolock) ON VOL.Cd_Tp_Embal = TC.Cd_Tp_Embal
		LEFT JOIN dbo.NCM AS NCM  WITH (nolock) ON NCM.Id_NCM = VOL.Id_NCM
		
		
UNION ALL

SELECT VOL.Num_Proc_HEM Num_Proc , Item_EM Item, Qtd_Vol_EM Qtd_Vol, Compr_EM Compr, Largura_EM Largura, 
			Altura_EM Altura, Cd_Tp_Unidade , Vol_Item_EM Vol_Item, VOL.Id_NCM,NCM.NCM, VOL.Peso_Bruto_EM Peso_Bruto, 
			VOL.Cd_Tp_Embal,TC.Nome_Tp_Embal, Marca_EM Marca,Contra_Marca Contra_Marca, VOL.Item_Cont_EM Item_Cont,
			MAS.Num_Cont_EM Num_Cont
FROM	Volume_Exp_Mar VOL
		LEFT JOIN dbo.Container_Mas_Exp_Mar AS MAS WITH (nolock) ON VOL.Item_Cont_EM = MAS.Item_Cont_EM
		LEFT JOIN	dbo.Container_Hou_Exp_Mar AS HOU WITH (nolock) ON HOU.Item_Cont_EM = MAS.Item_Cont_EM  AND VOL.Num_Proc_HEM = HOU.Num_Proc_HEM
				AND MAS.Num_Proc_MEM = HOU.Num_Proc_MEM 
		LEFT JOIN dbo.Tipo_Embalagem AS TC  WITH (nolock) ON VOL.Cd_Tp_Embal = TC.Cd_Tp_Embal
		LEFT JOIN dbo.NCM AS NCM  WITH (nolock) ON NCM.Id_NCM = VOL.Id_NCM




GO
