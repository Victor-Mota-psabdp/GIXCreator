SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[spHouse_BDP_OUT_Sel]

AS
	select Num_Proc_HBO from House_BDP_OUT order by CONVERT(datetime,Dt_Emis_HBO,103) desc
GO
