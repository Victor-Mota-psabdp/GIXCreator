SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwContainer]
AS
SELECT     JOB.Num_Proc AS Num_Proc,JOB.HAWB AS BL, MAS.Num_Cont_IM AS CONTAINER
FROM         dbo.vwALL_JOBs AS JOB WITH (nolock) INNER JOIN
                      dbo.Container_Hou_Imp_Mar AS HOU WITH (nolock) ON JOB.Num_Proc = HOU.Num_Proc_HIM INNER JOIN
                      dbo.Container_Mas_Imp_Mar AS MAS WITH (nolock) ON HOU.Item_Cont_IM = MAS.Item_Cont_IM AND MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
UNION ALL

select
	JOB.Num_Proc AS Num_Proc,HAWB AS BL,	Num_Cont_EM	AS CONTAINER
from vwALL_JOBs JOB With(nolock)
	JOIN dbo.Container_Hou_Exp_Mar AS HOU With(nolock) ON JOB.Num_Proc = HOU.Num_Proc_HEM
	JOIN dbo.Container_Mas_Exp_Mar AS MAS With(nolock) ON HOU.Item_Cont_EM = MAS.Item_Cont_EM AND MAS.Num_Proc_MEM = HOU.Num_Proc_MEM



GO
