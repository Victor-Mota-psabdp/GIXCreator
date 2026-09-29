SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATLDN_Site_Sel]
AS
select 
			Cd_Site			[Code],
			Nome_Site		[Site Name],
			Aliq_Pis		[Aliq_Pis],
			Aliq_Cofins		[Aliq_Cofins],
			Aliq_IRRF		[Aliq_IRRF],
			Aliq_CSLL		[Aliq_CSLL],			
			Aliq_ISS		[Aliq_ISS],
			Site_AX			[Site_AX],
			Status			[Enabled]
		from 
			Site T with(nolock)			
                       





GO
