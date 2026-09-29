SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[attrep_fn_NumericLsnToHexa](@numeric25Lsn numeric(25,0)) returns varchar(32)
 AS
 BEGIN
-- In order to avoid form sign overflow problems - declare the LSN segments 
-- to be one 'type' larger than the intendent target type.
-- For example, convert(smallint, convert(numeric(25,0),65535)) will fail 
-- but convert(binary(2), convert(int,convert(numeric(25,0),65535))) will give the 
-- expected result of 0xffff.

declare @high4bytelsnSegment bigint,@mid4bytelsnSegment bigint,@low2bytelsnSegment int
declare @highFactor bigint, @midFactor int

declare @lsnLeftSeg	binary(4)
declare @lsnMidSeg	binary(4)
declare @lsnRightSeg	binary(2)

declare	@hexaLsn	varchar(32)

select @highFactor = 1000000000000000
select @midFactor  = 100000

select @high4bytelsnSegment = convert(bigint, floor(@numeric25Lsn / @highFactor))
select @numeric25Lsn = @numeric25Lsn - convert(numeric(25,0), @high4bytelsnSegment) * @highFactor
select @mid4bytelsnSegment = convert(bigint,floor(@numeric25Lsn / @midFactor ))
select @numeric25Lsn = @numeric25Lsn - convert(numeric(25,0), @mid4bytelsnSegment) * @midFactor
select @low2bytelsnSegment = convert(int, @numeric25Lsn)

set	@lsnLeftSeg	= convert(binary(4), @high4bytelsnSegment)
set	@lsnMidSeg	= convert(binary(4), @mid4bytelsnSegment)
set   @lsnRightSeg	= convert(binary(2), @low2bytelsnSegment)

return [dbo].[attrep_fn_LsnSegmentToHexa](@lsnLeftSeg)+':'+[dbo].[attrep_fn_LsnSegmentToHexa](@lsnMidSeg)+':'+[dbo].[attrep_fn_LsnSegmentToHexa](@lsnRightSeg)
END

GO
