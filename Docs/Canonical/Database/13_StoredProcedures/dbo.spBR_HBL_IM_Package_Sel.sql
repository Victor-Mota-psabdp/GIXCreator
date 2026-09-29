SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create	PROCEDURE [dbo].[spBR_HBL_IM_Package_Sel]--'IMFLT201103005AR'
	@Processo	varchar(16)
As
	Select 
		NG.Descr					Packages_GOODS
	from 
		Nature_Goods NG
	where
		NG.num_proc=@Processo
GO
