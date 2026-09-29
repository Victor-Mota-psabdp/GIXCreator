SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP_HELP Container_Mas_Exp_Mar
create VIEW [dbo].[vwATL_Container]
AS
SELECT HOU.Num_Proc_HIM AS Num_Proc, HOU.Num_Proc_MIM AS Num_Proc_Master, HOU.Item_Cont_IM AS Item_Cont, 
		MAS.Cd_Tp_Cont, TC.Nome_Tp_Cont,
		MAS.Num_Cont_IM AS Num_Cont, MAS.Num_Lacre_IM AS Num_Lacre, 
		MAS.Dt_Vcto_Devol_IM AS Dt_Vcto_Devol,MAS.Dt_Devol_IM AS Dt_Devol, 
		MAS.Lacre_02_IM AS Lacre_02, MAS.Lacre_03_IM AS Lacre_03, MAS.Lacre_04_IM AS Lacre_04, 
		MAS.Peso_Bruto_IM AS Peso_Bruto, MAS.VolumeM3, MAS.ID_ISO, 
		MAS.Tara_IM AS Tara, MAS.DataDevCli_IM AS DataDevCli, MAS.inspecao,
		NULL Temperature,NULL Vent_Status,NULL Battery_Time,NULL Cd_Tp_Volt,NULL Graus,NULL Peso_Liquido
FROM	dbo.Container_Mas_Imp_Mar AS MAS WITH (nolock) INNER JOIN
		dbo.Container_Hou_Imp_Mar AS HOU WITH (nolock) ON HOU.Item_Cont_IM = MAS.Item_Cont_IM 
				AND MAS.Num_Proc_MIM = HOU.Num_Proc_MIM INNER JOIN 
		dbo.Tipo_Container AS TC  WITH (nolock) ON MAS.Cd_Tp_Cont = TC.Cd_Tp_Cont
				
UNION ALL
SELECT HOU.Num_Proc_HEM AS Num_Proc, HOU.Num_Proc_MEM AS Num_Proc_Master, HOU.Item_Cont_EM AS Item_Cont, 
		MAS.Cd_Tp_Cont, TC.Nome_Tp_Cont, 
       MAS.Num_Cont_EM AS Num_Cont, MAS.Num_Lacre_EM AS Num_Lacre, 
       convert(varchar(10),MAS.Dt_Vcto_Devol_EM,103) AS Dt_Vcto_Devol, convert(varchar(10),MAS.Dt_Est_Devol_EM,103) AS Dt_Devol, 
       MAS.Lacre_02_EM AS Lacre_02, MAS.Lacre_03_EM AS Lacre_03, MAS.Lacre_04_EM AS Lacre_04, MAS.Peso_Bruto_EM AS Peso_Bruto, MAS.VolumeM3, MAS.ID_ISO, 
       MAS.Tara_EM AS Tara, NULL AS DataDevCli, NULL inspecao,
       Temperature,Vent_Status,Battery_Time,Cd_Tp_Volt,Graus,Peso_Liquido_EM Peso_Liquido
FROM  dbo.Container_Mas_Exp_Mar AS MAS WITH (nolock) INNER JOIN
      dbo.Container_Hou_Exp_Mar AS HOU WITH (nolock) ON HOU.Item_Cont_EM = MAS.Item_Cont_EM  AND MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
      INNER JOIN Tipo_Container AS TC  WITH (nolock) ON MAS.Cd_Tp_Cont = TC.Cd_Tp_Cont
				AND MAS.Num_Proc_MEM = HOU.Num_Proc_MEM






GO
