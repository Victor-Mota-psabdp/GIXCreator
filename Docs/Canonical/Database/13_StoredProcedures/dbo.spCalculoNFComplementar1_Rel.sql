SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[spCalculoNFComplementar1_Rel] 'IMSUR20101000101'
CREATE Procedure [dbo].[spCalculoNFComplementar1_Rel]
	(@Num_Proc varchar(16))
AS
	select 
		@Num_Proc [JOB], dbo.fBusca_Docs_PO_Modal(@Num_Proc,1) [PO], HOU.cd_tp_oper [Incoterm], dbo.fBusca_Docs_PO_Modal(@Num_Proc,5) [D.I.]
	from
		House_Imp_Mar hou
	where 
		HOU.num_proc_him=@Num_Proc

UNION ALL
	select 
		@Num_Proc [JOB], dbo.fBusca_Docs_PO_Modal(@Num_Proc,1) [PO], HOU.cd_tp_oper [Incoterm], dbo.fBusca_Docs_PO_Modal(@Num_Proc,5) [D.I.]
	from
		House_Imp_Aer hou
	where 
		HOU.num_proc_hia=@Num_Proc





GO
